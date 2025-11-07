package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"

	"github.com/gin-gonic/gin"
)

type ConfigurationHandler struct {
	db *sql.DB
}

func NewConfigurationHandler(db *sql.DB) *ConfigurationHandler {
	return &ConfigurationHandler{db: db}
}

// GetConfiguration handles GET /api/v2/configurations
func (h *ConfigurationHandler) GetConfiguration(c *gin.Context) {
	config, err := models.GetConfiguration(h.db)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve configuration: "+err.Error())
		return
	}

	if config == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Configuration not found")
		return
	}

	utils.SuccessResponse(c, http.StatusOK, config)
}

// UpdateConfiguration handles PATCH /api/v2/configurations
func (h *ConfigurationHandler) UpdateConfiguration(c *gin.Context) {
	var input models.ConfigurationUpdate

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	// In a real application, get updatedBy from authentication context
	updatedBy := c.GetString("user_id")
	if updatedBy == "" {
		updatedBy = "system"
	}

	config, err := models.UpdateConfiguration(h.db, input, updatedBy)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to update configuration: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, config)
}
