package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"

	"github.com/gin-gonic/gin"
)

type NotificationHandler struct {
	db *sql.DB
}

func NewNotificationHandler(db *sql.DB) *NotificationHandler {
	return &NotificationHandler{db: db}
}

// GetNotifications handles GET /api/v2/notifications
func (h *NotificationHandler) GetNotifications(c *gin.Context) {
	staffID := c.Query("staffId")
	incidentID := c.Query("incidentId")
	unreadOnly := c.Query("unreadOnly") == "true"

	var staffIDPtr, incidentIDPtr *string

	if staffID != "" {
		staffIDPtr = &staffID
	}
	if incidentID != "" {
		incidentIDPtr = &incidentID
	}

	notifications, err := models.GetNotifications(h.db, staffIDPtr, incidentIDPtr, unreadOnly)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve notifications: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, notifications)
}

// CreateNotification handles POST /api/v2/notifications
func (h *NotificationHandler) CreateNotification(c *gin.Context) {
	var input models.NotificationCreate

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	// Validate required fields
	if input.IncidentID == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "incidentId is required")
		return
	}
	if len(input.SentToStaffIDs) == 0 {
		utils.ErrorResponse(c, http.StatusBadRequest, "sentToStaffIds is required and must not be empty")
		return
	}

	notification, err := models.CreateNotification(h.db, input)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to create notification: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusCreated, notification)
}

// MarkNotificationAsRead handles POST /api/v2/notifications/:id/mark-read
func (h *NotificationHandler) MarkNotificationAsRead(c *gin.Context) {
	notificationID := c.Param("id")

	var input struct {
		StaffID string `json:"staffId"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	if input.StaffID == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "staffId is required")
		return
	}

	err := models.MarkNotificationAsRead(h.db, notificationID, input.StaffID)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to mark notification as read: "+err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Notification marked as read successfully",
	})
}

// EscalateNotification handles POST /api/v2/notifications/:id/escalate
func (h *NotificationHandler) EscalateNotification(c *gin.Context) {
	notificationID := c.Param("id")

	err := models.EscalateNotification(h.db, notificationID)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to escalate notification: "+err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Notification escalated successfully",
	})
}
