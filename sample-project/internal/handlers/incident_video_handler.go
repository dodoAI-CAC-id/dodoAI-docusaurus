package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"

	"github.com/gin-gonic/gin"
)

type IncidentVideoHandler struct {
	db *sql.DB
}

func NewIncidentVideoHandler(db *sql.DB) *IncidentVideoHandler {
	return &IncidentVideoHandler{db: db}
}

// GetIncidentVideos handles GET /api/v2/incidents/:id/videos
func (h *IncidentVideoHandler) GetIncidentVideos(c *gin.Context) {
	incidentID := c.Param("id")

	videos, err := models.GetVideosByIncidentID(h.db, incidentID)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve videos: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, videos)
}

// GetVideoFile handles GET /api/v2/videos/:id/file
func (h *IncidentVideoHandler) GetVideoFile(c *gin.Context) {
	videoID := c.Param("id")

	video, err := models.GetVideoByID(h.db, videoID)
	if err == sql.ErrNoRows || video == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Video not found")
		return
	}
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve video: "+err.Error())
		return
	}

	// In a real implementation, this would stream the video file from storage
	// For now, redirect to the file URL or return a placeholder
	if video.FileURL != "" {
		c.Redirect(http.StatusFound, video.FileURL)
		return
	}

	utils.ErrorResponse(c, http.StatusNotFound, "Video file not available")
}
