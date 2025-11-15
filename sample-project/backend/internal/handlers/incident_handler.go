package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"
	"time"

	"github.com/gin-gonic/gin"
)

type IncidentHandler struct {
	db *sql.DB
}

func NewIncidentHandler(db *sql.DB) *IncidentHandler {
	return &IncidentHandler{db: db}
}

// GetIncidents handles GET /api/v2/incidents
func (h *IncidentHandler) GetIncidents(c *gin.Context) {
	// Parse query parameters
	personID := c.Query("personId")
	status := c.Query("status")
	fromStr := c.Query("from")
	toStr := c.Query("to")

	var personIDPtr, statusPtr *string
	var fromPtr, toPtr *time.Time

	if personID != "" {
		personIDPtr = &personID
	}
	if status != "" {
		statusPtr = &status
	}

	if fromStr != "" {
		from, err := time.Parse(time.RFC3339, fromStr)
		if err != nil {
			utils.ErrorResponse(c, http.StatusBadRequest, "Invalid 'from' timestamp format")
			return
		}
		fromPtr = &from
	}

	if toStr != "" {
		to, err := time.Parse(time.RFC3339, toStr)
		if err != nil {
			utils.ErrorResponse(c, http.StatusBadRequest, "Invalid 'to' timestamp format")
			return
		}
		toPtr = &to
	}

	incidents, err := models.GetAllIncidents(h.db, personIDPtr, statusPtr, fromPtr, toPtr)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve incidents: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, incidents)
}

// CreateIncident handles POST /api/v2/incidents
func (h *IncidentHandler) CreateIncident(c *gin.Context) {
	var input models.IncidentCreate

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	// Validate required fields
	if input.DetectedAt.IsZero() {
		utils.ErrorResponse(c, http.StatusBadRequest, "detectedAt is required")
		return
	}
	if input.Type == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "type is required")
		return
	}
	if input.PersonID == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "personId is required")
		return
	}
	if input.CameraID == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "cameraId is required")
		return
	}

	incident, err := models.CreateIncident(h.db, input)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to create incident: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusCreated, incident)
}

// GetIncident handles GET /api/v2/incidents/:id
func (h *IncidentHandler) GetIncident(c *gin.Context) {
	incidentID := c.Param("id")

	incident, err := models.GetIncidentByID(h.db, incidentID)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.ErrorResponse(c, http.StatusNotFound, "Incident not found")
			return
		}
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve incident: "+err.Error())
		return
	}
	if incident == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Incident not found")
		return
	}

	utils.SuccessResponse(c, http.StatusOK, incident)
}

// UpdateIncident handles PATCH /api/v2/incidents/:id
func (h *IncidentHandler) UpdateIncident(c *gin.Context) {
	incidentID := c.Param("id")

	var input models.IncidentUpdate
	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	incident, err := models.UpdateIncident(h.db, incidentID, input)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.ErrorResponse(c, http.StatusNotFound, "Incident not found")
			return
		}
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to update incident: "+err.Error())
		return
	}
	if incident == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Incident not found")
		return
	}

	utils.SuccessResponse(c, http.StatusOK, incident)
}

// ToggleAlertStatus handles PATCH /api/v2/incidents/:id/alert
func (h *IncidentHandler) ToggleAlertStatus(c *gin.Context) {
	incidentID := c.Param("id")

	var input struct {
		IsActive *bool `json:"isActive"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	// Validate required field
	if input.IsActive == nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "isActive field is required")
		return
	}

	incident, err := models.ToggleAlertStatus(h.db, incidentID, *input.IsActive)
	if err != nil {
		if err == sql.ErrNoRows {
			utils.ErrorResponse(c, http.StatusNotFound, "Incident not found")
			return
		}
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to toggle alert status: "+err.Error())
		return
	}
	if incident == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Incident not found")
		return
	}

	utils.SuccessResponse(c, http.StatusOK, incident)
}
