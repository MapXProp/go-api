package handlers

import "github.com/google/uuid"

// The active project join supplies identity; neither names nor shared map
// coordinates establish membership. Apply this before counting and pagination.
func projectIdentifierPredicate(identifier string, arg func(any) string) string {
	slugArg := arg(identifier)
	if publicID, err := uuid.Parse(identifier); err == nil {
		return "(project.slug = " + slugArg + " OR project.public_project_id = " + arg(publicID.String()) + "::uuid)"
	}
	return "project.slug = " + slugArg
}
