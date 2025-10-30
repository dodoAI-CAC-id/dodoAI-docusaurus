package models

import (
	"database/sql"
	"time"

	"github.com/lib/pq"
)

// Room represents a monitoring room
type Room struct {
	ID                string    `json:"id"`
	RoomNumber        string    `json:"roomNumber"`
	Description       *string   `json:"description,omitempty"`
	AssignedPersonIDs []string  `json:"assignedPersonIds,omitempty"`
	CameraDeviceIDs   []string  `json:"cameraDeviceIds,omitempty"`
	CreatedAt         time.Time `json:"createdAt"`
	UpdatedAt         time.Time `json:"updatedAt"`
}

// GetAllRooms retrieves all rooms
func GetAllRooms(db *sql.DB) ([]Room, error) {
	query := `
		SELECT id, room_number, description, created_at, updated_at
		FROM rooms
		ORDER BY room_number
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var rooms []Room
	for rows.Next() {
		var room Room
		err := rows.Scan(
			&room.ID,
			&room.RoomNumber,
			&room.Description,
			&room.CreatedAt,
			&room.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}

		// Get assigned persons
		personQuery := `SELECT id FROM persons WHERE room_id = $1`
		personRows, err := db.Query(personQuery, room.ID)
		if err != nil {
			return nil, err
		}
		var personIDs []string
		for personRows.Next() {
			var personID string
			if err := personRows.Scan(&personID); err != nil {
				personRows.Close()
				return nil, err
			}
			personIDs = append(personIDs, personID)
		}
		personRows.Close()
		room.AssignedPersonIDs = personIDs

		// Get camera devices
		cameraQuery := `SELECT id FROM camera_devices WHERE room_id = $1`
		cameraRows, err := db.Query(cameraQuery, room.ID)
		if err != nil {
			return nil, err
		}
		var cameraIDs []string
		for cameraRows.Next() {
			var cameraID string
			if err := cameraRows.Scan(&cameraID); err != nil {
				cameraRows.Close()
				return nil, err
			}
			cameraIDs = append(cameraIDs, cameraID)
		}
		cameraRows.Close()
		room.CameraDeviceIDs = cameraIDs

		rooms = append(rooms, room)
	}

	return rooms, rows.Err()
}

// GetRoomByID retrieves a specific room by ID
func GetRoomByID(db *sql.DB, id string) (*Room, error) {
	query := `
		SELECT id, room_number, description, created_at, updated_at
		FROM rooms
		WHERE id = $1
	`

	var room Room
	err := db.QueryRow(query, id).Scan(
		&room.ID,
		&room.RoomNumber,
		&room.Description,
		&room.CreatedAt,
		&room.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	// Get assigned persons
	personQuery := `SELECT id FROM persons WHERE room_id = $1`
	personRows, err := db.Query(personQuery, room.ID)
	if err != nil {
		return nil, err
	}
	defer personRows.Close()

	var personIDs []string
	for personRows.Next() {
		var personID string
		if err := personRows.Scan(&personID); err != nil {
			return nil, err
		}
		personIDs = append(personIDs, personID)
	}
	room.AssignedPersonIDs = personIDs

	// Get camera devices
	cameraQuery := `SELECT id FROM camera_devices WHERE room_id = $1`
	cameraRows, err := db.Query(cameraQuery, room.ID)
	if err != nil {
		return nil, err
	}
	defer cameraRows.Close()

	var cameraIDs []string
	for cameraRows.Next() {
		var cameraID string
		if err := cameraRows.Scan(&cameraID); err != nil {
			return nil, err
		}
		cameraIDs = append(cameraIDs, cameraID)
	}
	room.CameraDeviceIDs = cameraIDs

	return &room, nil
}

// CameraDevice represents a camera device
type CameraDevice struct {
	ID           string     `json:"id"`
	SerialNumber string     `json:"serialNumber"`
	RoomID       *string    `json:"roomId,omitempty"`
	Model        *string    `json:"model,omitempty"`
	InstallDate  *time.Time `json:"installDate,omitempty"`
	Status       string     `json:"status"`
	CreatedAt    time.Time  `json:"createdAt"`
	UpdatedAt    time.Time  `json:"updatedAt"`
}

// GetAllCameraDevices retrieves all camera devices
func GetAllCameraDevices(db *sql.DB) ([]CameraDevice, error) {
	query := `
		SELECT id, serial_number, room_id, model, install_date, status, created_at, updated_at
		FROM camera_devices
		ORDER BY serial_number
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var cameras []CameraDevice
	for rows.Next() {
		var camera CameraDevice
		err := rows.Scan(
			&camera.ID,
			&camera.SerialNumber,
			&camera.RoomID,
			&camera.Model,
			&camera.InstallDate,
			&camera.Status,
			&camera.CreatedAt,
			&camera.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		cameras = append(cameras, camera)
	}

	return cameras, rows.Err()
}

// GetCameraDeviceByID retrieves a specific camera device by ID
func GetCameraDeviceByID(db *sql.DB, id string) (*CameraDevice, error) {
	query := `
		SELECT id, serial_number, room_id, model, install_date, status, created_at, updated_at
		FROM camera_devices
		WHERE id = $1
	`

	var camera CameraDevice
	err := db.QueryRow(query, id).Scan(
		&camera.ID,
		&camera.SerialNumber,
		&camera.RoomID,
		&camera.Model,
		&camera.InstallDate,
		&camera.Status,
		&camera.CreatedAt,
		&camera.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &camera, nil
}

// DetectionArea represents a detection area for a camera
type DetectionArea struct {
	ID        string    `json:"id"`
	CameraID  string    `json:"cameraId"`
	Name      string    `json:"name"`
	AreaShape *string   `json:"areaShape,omitempty"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// GetAllDetectionAreas retrieves all detection areas, optionally filtered by camera
func GetAllDetectionAreas(db *sql.DB, cameraID *string) ([]DetectionArea, error) {
	query := `
		SELECT id, camera_id, name, area_shape, created_at, updated_at
		FROM detection_areas
		WHERE 1=1
	`
	args := []interface{}{}

	if cameraID != nil {
		query += ` AND camera_id = $1`
		args = append(args, *cameraID)
	}

	query += ` ORDER BY name`

	rows, err := db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var areas []DetectionArea
	for rows.Next() {
		var area DetectionArea
		err := rows.Scan(
			&area.ID,
			&area.CameraID,
			&area.Name,
			&area.AreaShape,
			&area.CreatedAt,
			&area.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		areas = append(areas, area)
	}

	return areas, rows.Err()
}

// Suppress unused import warning
var _ = pq.Array
