package handlers

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"
)

type resendEmailRequest struct {
	From    string   `json:"from"`
	To      []string `json:"to"`
	Subject string   `json:"subject"`
	HTML    string   `json:"html"`
	Text    string   `json:"text"`
}

func frontendURL() string {
	if value := strings.TrimSpace(os.Getenv("FRONTEND_URL")); value != "" {
		return strings.TrimRight(value, "/")
	}
	return "http://localhost:3000"
}

func resendFromEmail() string {
	if value := strings.TrimSpace(os.Getenv("RESEND_FROM_EMAIL")); value != "" {
		return value
	}
	return "MapxProp <no-reply@mapxprop.com>"
}

func sendResendEmail(ctx context.Context, payload resendEmailRequest) error {
	apiKey := strings.TrimSpace(os.Getenv("RESEND_API_KEY"))
	if apiKey == "" {
		return fmt.Errorf("RESEND_API_KEY is not configured")
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return err
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, "https://api.resend.com/emails", bytes.NewReader(body))
	if err != nil {
		return err
	}
	req.Header.Set("Authorization", "Bearer "+apiKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return fmt.Errorf("resend email failed with status %d", resp.StatusCode)
	}

	return nil
}
