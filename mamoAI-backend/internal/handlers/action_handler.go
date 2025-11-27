package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"

	"github.com/gin-gonic/gin"
)

type ActionHandler struct {
	db *sql.DB
}

func NewActionHandler(db *sql.DB) *ActionHandler {
	return &ActionHandler{db: db}
}

// GetActionsByIncident handles GET /api/v2/incidents/:id/actions
func (h *ActionHandler) GetActionsByIncident(c *gin.Context) {
	incidentID := c.Param("id")

	actions, err := models.GetActionsWithDetailsByIncidentID(h.db, incidentID)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve actions: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, actions)
}

// CreateAction handles POST /api/v2/incidents/:id/actions
func (h *ActionHandler) CreateAction(c *gin.Context) {
	incidentID := c.Param("id")

	var input models.ActionCreate
	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	// Validate required fields
	if input.StaffID == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "staffId is required")
		return
	}
	if input.ActionType == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "actionType is required")
		return
	}

	action, err := models.CreateAction(h.db, incidentID, input)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to create action: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusCreated, action)
}
