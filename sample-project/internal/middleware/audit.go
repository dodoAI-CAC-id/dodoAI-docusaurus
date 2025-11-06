package middleware

import (
	"database/sql"
	"sample-project/internal/models"
	"time"

	"github.com/gin-gonic/gin"
)

// AuditLogMiddleware logs all API requests to the audit_logs table
func AuditLogMiddleware(db *sql.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Record start time
		startTime := time.Now()

		// Process request
		c.Next()

		// Record audit log after request is processed
		go func() {
			duration := time.Since(startTime)

			// Get operator ID from context (if available)
			// In a real application, this would come from authentication
			operatorID := c.GetString("user_id")
			if operatorID == "" {
				operatorID = "system" // Default for unauthenticated requests
			}

			// Determine operation type based on HTTP method
			operation := c.Request.Method + " " + c.Request.URL.Path

			// Determine target type and ID from URL
			targetType := "unknown"
			targetID := ""

			// Extract target information from path parameters
			if id := c.Param("id"); id != "" {
				targetID = id
			}
			if incidentID := c.Param("incidentId"); incidentID != "" {
				targetID = incidentID
				targetType = "incident"
			}
			if videoID := c.Param("videoId"); videoID != "" {
				targetID = videoID
				targetType = "video"
			}
			if notificationID := c.Param("notificationId"); notificationID != "" {
				targetID = notificationID
				targetType = "notification"
			}

			// Create detail with status code and duration
			detail := ""
			if c.Writer.Status() >= 400 {
				detail = "Status: " + string(rune('0'+c.Writer.Status()/100)) + "xx, Duration: " + string(rune('0'+int(duration.Milliseconds()))) + "ms"
			}

			// Save to database (ignore errors in background operation)
			var detailPtr *string
			if detail != "" {
				detailPtr = &detail
			}
			_ = models.CreateAuditLog(db, operation, &operatorID, &targetType, &targetID, detailPtr)
		}()
	}
}
