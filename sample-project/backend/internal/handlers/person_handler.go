package handlers

import (
	"database/sql"
	"net/http"
	"sample-project/internal/models"
	"sample-project/internal/utils"

	"github.com/gin-gonic/gin"
)

type PersonHandler struct {
	db *sql.DB
}

func NewPersonHandler(db *sql.DB) *PersonHandler {
	return &PersonHandler{db: db}
}

// GetPersons handles GET /api/v2/persons
func (h *PersonHandler) GetPersons(c *gin.Context) {
	persons, err := models.GetAllPersons(h.db)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve persons: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, persons)
}

// GetPerson handles GET /api/v2/persons/:id
func (h *PersonHandler) GetPerson(c *gin.Context) {
	personID := c.Param("id")

	person, err := models.GetPersonByID(h.db, personID)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to retrieve person: "+err.Error())
		return
	}
	if person == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Person not found")
		return
	}

	utils.SuccessResponse(c, http.StatusOK, person)
}

// CreatePerson handles POST /api/v2/persons
func (h *PersonHandler) CreatePerson(c *gin.Context) {
	var input models.PersonCreate

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	// Validate required fields
	if input.Name == "" {
		utils.ErrorResponse(c, http.StatusBadRequest, "name is required")
		return
	}

	person, err := models.CreatePerson(h.db, input)
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to create person: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusCreated, person)
}

// UpdatePerson handles PATCH /api/v2/persons/:id
func (h *PersonHandler) UpdatePerson(c *gin.Context) {
	personID := c.Param("id")

	var input models.PersonUpdate
	if err := c.ShouldBindJSON(&input); err != nil {
		utils.ErrorResponse(c, http.StatusBadRequest, "Invalid request body: "+err.Error())
		return
	}

	person, err := models.UpdatePerson(h.db, personID, input)
	if err == sql.ErrNoRows || person == nil {
		utils.ErrorResponse(c, http.StatusNotFound, "Person not found")
		return
	}
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to update person: "+err.Error())
		return
	}

	utils.SuccessResponse(c, http.StatusOK, person)
}

// DeletePerson handles DELETE /api/v2/persons/:id
func (h *PersonHandler) DeletePerson(c *gin.Context) {
	personID := c.Param("id")

	err := models.DeletePerson(h.db, personID)
	if err == sql.ErrNoRows {
		utils.ErrorResponse(c, http.StatusNotFound, "Person not found")
		return
	}
	if err != nil {
		utils.ErrorResponse(c, http.StatusInternalServerError, "Failed to delete person: "+err.Error())
		return
	}

	utils.MessageResponse(c, http.StatusOK, "Person deleted successfully")
}
