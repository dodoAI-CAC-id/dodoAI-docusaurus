package utils

import (
	"github.com/gin-gonic/gin"
)

// ErrorResponse sends a standardized error response
func ErrorResponse(c *gin.Context, statusCode int, message string) {
	c.JSON(statusCode, gin.H{
		"success": false,
		"message": message,
	})
}

// SuccessResponse sends a standardized success response
func SuccessResponse(c *gin.Context, statusCode int, data interface{}) {
	c.JSON(statusCode, gin.H{
		"success": true,
		"data":    data,
	})
}

// MessageResponse sends a simple message response
func MessageResponse(c *gin.Context, statusCode int, message string) {
	c.JSON(statusCode, gin.H{
		"success": true,
		"message": message,
	})
}
