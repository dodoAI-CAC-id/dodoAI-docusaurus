package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"

	"github.com/gin-gonic/gin"
)

type RoomHandler struct {
	db *sql.DB
}

func NewRoomHandler(db *sql.DB) *RoomHandler {
	return &RoomHandler{db: db}
}

// GetRooms handles GET /api/v2/rooms
func (h *RoomHandler) GetRooms(c *gin.Context) {
	rooms, err := models.GetAllRooms(h.db)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve rooms: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, rooms)
}

// GetRoom handles GET /api/v2/rooms/:id
func (h *RoomHandler) GetRoom(c *gin.Context) {
	roomID := c.Param("id")

	room, err := models.GetRoomByID(h.db, roomID)
	if err == sql.ErrNoRows || room == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Room not found")
		return
	}
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve room: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, room)
}

// GetCameraDevices handles GET /api/v2/camera-devices
func (h *RoomHandler) GetCameraDevices(c *gin.Context) {
	cameras, err := models.GetAllCameraDevices(h.db)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve camera devices: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, cameras)
}

// GetCameraDevice handles GET /api/v2/camera-devices/:id
func (h *RoomHandler) GetCameraDevice(c *gin.Context) {
	cameraID := c.Param("id")

	camera, err := models.GetCameraDeviceByID(h.db, cameraID)
	if err == sql.ErrNoRows || camera == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Camera device not found")
		return
	}
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve camera device: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, camera)
}

// GetDetectionAreas handles GET /api/v2/detection-areas
func (h *RoomHandler) GetDetectionAreas(c *gin.Context) {
	cameraID := c.Query("cameraId")

	var cameraIDPtr *string
	if cameraID != "" {
		cameraIDPtr = &cameraID
	}

	areas, err := models.GetAllDetectionAreas(h.db, cameraIDPtr)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve detection areas: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, areas)
}
