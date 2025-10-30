package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"

	"github.com/gin-gonic/gin"
)

type StaffHandler struct {
	db *sql.DB
}

func NewStaffHandler(db *sql.DB) *StaffHandler {
	return &StaffHandler{db: db}
}

// GetStaffs handles GET /api/v2/staffs
func (h *StaffHandler) GetStaffs(c *gin.Context) {
	staffs, err := models.GetAllStaffs(h.db)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve staffs: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, staffs)
}

// GetStaff handles GET /api/v2/staffs/:id
func (h *StaffHandler) GetStaff(c *gin.Context) {
	staffID := c.Param("id")

	staff, err := models.GetStaffByID(h.db, staffID)
	if err == sql.ErrNoRows || staff == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Staff not found")
		return
	}
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve staff: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, staff)
}

// GetDepartments handles GET /api/v2/departments
func (h *StaffHandler) GetDepartments(c *gin.Context) {
	departments, err := models.GetAllDepartments(h.db)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve departments: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, departments)
}
