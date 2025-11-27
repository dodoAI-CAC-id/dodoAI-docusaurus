package handlers

import (
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"
	"time"

	"database/sql"

	"github.com/gin-gonic/gin"
)

type AuditLogHandler struct {
	db *sql.DB
}

func NewAuditLogHandler(db *sql.DB) *AuditLogHandler {
	return &AuditLogHandler{db: db}
}

// GetAuditLogs handles GET /api/v2/audit-logs
func (h *AuditLogHandler) GetAuditLogs(c *gin.Context) {
	targetType := c.Query("targetType")
	userID := c.Query("userId")
	operation := c.Query("operation")
	fromStr := c.Query("from")
	toStr := c.Query("to")

	var targetTypePtr, userIDPtr, operationPtr *string
	var fromPtr, toPtr *time.Time

	if targetType != "" {
		targetTypePtr = &targetType
	}
	if userID != "" {
		userIDPtr = &userID
	}
	if operation != "" {
		operationPtr = &operation
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

	logs, err := models.GetAuditLogs(h.db, targetTypePtr, userIDPtr, operationPtr, fromPtr, toPtr)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve audit logs: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, logs)
}
