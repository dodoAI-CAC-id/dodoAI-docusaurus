package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetAllRooms Tests ====================

func TestGetAllRooms_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()
	desc := "個室"

	// Mock rooms query
	roomRows := sqlmock.NewRows([]string{
		"id", "room_number", "description", "created_at", "updated_at",
	}).
		AddRow("room-1", "101", &desc, now, now).
		AddRow("room-2", "102", nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM rooms ORDER BY room_number").
		WillReturnRows(roomRows)

	// Mock persons query for room-1
	personRows1 := sqlmock.NewRows([]string{"id"}).
		AddRow("person-1").
		AddRow("person-2")
	mock.ExpectQuery("SELECT id FROM persons WHERE room_id = (.+)").
		WithArgs("room-1").
		WillReturnRows(personRows1)

	// Mock cameras query for room-1
	cameraRows1 := sqlmock.NewRows([]string{"id"}).
		AddRow("camera-1")
	mock.ExpectQuery("SELECT id FROM camera_devices WHERE room_id = (.+)").
		WithArgs("room-1").
		WillReturnRows(cameraRows1)

	// Mock persons query for room-2
	personRows2 := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM persons WHERE room_id = (.+)").
		WithArgs("room-2").
		WillReturnRows(personRows2)

	// Mock cameras query for room-2
	cameraRows2 := sqlmock.NewRows([]string{"id"}).
		AddRow("camera-2")
	mock.ExpectQuery("SELECT id FROM camera_devices WHERE room_id = (.+)").
		WithArgs("room-2").
		WillReturnRows(cameraRows2)

	// Execute
	rooms, err := GetAllRooms(db)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, rooms, 2)
	assert.Equal(t, "room-1", rooms[0].ID)
	assert.Equal(t, "101", rooms[0].RoomNumber)
	assert.NotNil(t, rooms[0].Description)
	assert.Equal(t, desc, *rooms[0].Description)
	assert.Len(t, rooms[0].AssignedPersonIDs, 2)
	assert.Contains(t, rooms[0].AssignedPersonIDs, "person-1")
	assert.Contains(t, rooms[0].AssignedPersonIDs, "person-2")
	assert.Len(t, rooms[0].CameraDeviceIDs, 1)
	assert.Contains(t, rooms[0].CameraDeviceIDs, "camera-1")

	assert.Equal(t, "room-2", rooms[1].ID)
	assert.Equal(t, "102", rooms[1].RoomNumber)
	assert.Nil(t, rooms[1].Description)
	assert.Empty(t, rooms[1].AssignedPersonIDs)
	assert.Len(t, rooms[1].CameraDeviceIDs, 1)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllRooms_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	roomRows := sqlmock.NewRows([]string{
		"id", "room_number", "description", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM rooms ORDER BY room_number").
		WillReturnRows(roomRows)

	// Execute
	rooms, err := GetAllRooms(db)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, rooms)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllRooms_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM rooms ORDER BY room_number").
		WillReturnError(sql.ErrConnDone)

	// Execute
	rooms, err := GetAllRooms(db)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, rooms)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetRoomByID Tests ====================

func TestGetRoomByID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	roomID := "room-1"
	now := time.Now()
	desc := "個室"

	// Mock room query
	roomRows := sqlmock.NewRows([]string{
		"id", "room_number", "description", "created_at", "updated_at",
	}).
		AddRow(roomID, "101", &desc, now, now)

	mock.ExpectQuery("SELECT (.+) FROM rooms WHERE id = (.+)").
		WithArgs(roomID).
		WillReturnRows(roomRows)

	// Mock persons query
	personRows := sqlmock.NewRows([]string{"id"}).
		AddRow("person-1")
	mock.ExpectQuery("SELECT id FROM persons WHERE room_id = (.+)").
		WithArgs(roomID).
		WillReturnRows(personRows)

	// Mock cameras query
	cameraRows := sqlmock.NewRows([]string{"id"}).
		AddRow("camera-1").
		AddRow("camera-2")
	mock.ExpectQuery("SELECT id FROM camera_devices WHERE room_id = (.+)").
		WithArgs(roomID).
		WillReturnRows(cameraRows)

	// Execute
	room, err := GetRoomByID(db, roomID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, room)
	assert.Equal(t, roomID, room.ID)
	assert.Equal(t, "101", room.RoomNumber)
	assert.NotNil(t, room.Description)
	assert.Equal(t, desc, *room.Description)
	assert.Len(t, room.AssignedPersonIDs, 1)
	assert.Contains(t, room.AssignedPersonIDs, "person-1")
	assert.Len(t, room.CameraDeviceIDs, 2)
	assert.Contains(t, room.CameraDeviceIDs, "camera-1")
	assert.Contains(t, room.CameraDeviceIDs, "camera-2")
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetRoomByID_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	roomID := "non-existent-id"

	mock.ExpectQuery("SELECT (.+) FROM rooms WHERE id = (.+)").
		WithArgs(roomID).
		WillReturnError(sql.ErrNoRows)

	// Execute
	room, err := GetRoomByID(db, roomID)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, room)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetRoomByID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	roomID := "room-1"

	mock.ExpectQuery("SELECT (.+) FROM rooms WHERE id = (.+)").
		WithArgs(roomID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	room, err := GetRoomByID(db, roomID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, room)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetAllCameraDevices Tests ====================

func TestGetAllCameraDevices_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()
	installDate := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	roomID := "room-1"
	model := "Camera-X100"

	rows := sqlmock.NewRows([]string{
		"id", "serial_number", "room_id", "model", "install_date", "status", "created_at", "updated_at",
	}).
		AddRow("camera-1", "SN-001", &roomID, &model, &installDate, "active", now, now).
		AddRow("camera-2", "SN-002", nil, nil, nil, "inactive", now, now)

	mock.ExpectQuery("SELECT (.+) FROM camera_devices ORDER BY serial_number").
		WillReturnRows(rows)

	// Execute
	cameras, err := GetAllCameraDevices(db)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, cameras, 2)
	assert.Equal(t, "camera-1", cameras[0].ID)
	assert.Equal(t, "SN-001", cameras[0].SerialNumber)
	assert.Equal(t, "active", cameras[0].Status)
	assert.NotNil(t, cameras[0].RoomID)
	assert.Equal(t, roomID, *cameras[0].RoomID)
	assert.NotNil(t, cameras[0].Model)
	assert.Equal(t, model, *cameras[0].Model)
	assert.NotNil(t, cameras[0].InstallDate)

	assert.Equal(t, "camera-2", cameras[1].ID)
	assert.Equal(t, "inactive", cameras[1].Status)
	assert.Nil(t, cameras[1].RoomID)
	assert.Nil(t, cameras[1].Model)
	assert.Nil(t, cameras[1].InstallDate)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllCameraDevices_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	rows := sqlmock.NewRows([]string{
		"id", "serial_number", "room_id", "model", "install_date", "status", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM camera_devices ORDER BY serial_number").
		WillReturnRows(rows)

	// Execute
	cameras, err := GetAllCameraDevices(db)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, cameras)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllCameraDevices_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM camera_devices ORDER BY serial_number").
		WillReturnError(sql.ErrConnDone)

	// Execute
	cameras, err := GetAllCameraDevices(db)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, cameras)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetCameraDeviceByID Tests ====================

func TestGetCameraDeviceByID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	cameraID := "camera-1"
	now := time.Now()
	roomID := "room-1"
	model := "Camera-X100"
	installDate := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)

	rows := sqlmock.NewRows([]string{
		"id", "serial_number", "room_id", "model", "install_date", "status", "created_at", "updated_at",
	}).
		AddRow(cameraID, "SN-001", &roomID, &model, &installDate, "active", now, now)

	mock.ExpectQuery("SELECT (.+) FROM camera_devices WHERE id = (.+)").
		WithArgs(cameraID).
		WillReturnRows(rows)

	// Execute
	camera, err := GetCameraDeviceByID(db, cameraID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, camera)
	assert.Equal(t, cameraID, camera.ID)
	assert.Equal(t, "SN-001", camera.SerialNumber)
	assert.Equal(t, "active", camera.Status)
	assert.NotNil(t, camera.RoomID)
	assert.Equal(t, roomID, *camera.RoomID)
	assert.NotNil(t, camera.Model)
	assert.Equal(t, model, *camera.Model)
	assert.NotNil(t, camera.InstallDate)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetCameraDeviceByID_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	cameraID := "non-existent-id"

	mock.ExpectQuery("SELECT (.+) FROM camera_devices WHERE id = (.+)").
		WithArgs(cameraID).
		WillReturnError(sql.ErrNoRows)

	// Execute
	camera, err := GetCameraDeviceByID(db, cameraID)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, camera)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetCameraDeviceByID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	cameraID := "camera-1"

	mock.ExpectQuery("SELECT (.+) FROM camera_devices WHERE id = (.+)").
		WithArgs(cameraID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	camera, err := GetCameraDeviceByID(db, cameraID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, camera)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetAllDetectionAreas Tests ====================

func TestGetAllDetectionAreas_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()
	areaShape := "polygon"

	rows := sqlmock.NewRows([]string{
		"id", "camera_id", "name", "area_shape", "created_at", "updated_at",
	}).
		AddRow("area-1", "camera-1", "エリアA", &areaShape, now, now).
		AddRow("area-2", "camera-1", "エリアB", nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 ORDER BY name").
		WillReturnRows(rows)

	// Execute
	areas, err := GetAllDetectionAreas(db, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, areas, 2)
	assert.Equal(t, "area-1", areas[0].ID)
	assert.Equal(t, "camera-1", areas[0].CameraID)
	assert.Equal(t, "エリアA", areas[0].Name)
	assert.NotNil(t, areas[0].AreaShape)
	assert.Equal(t, areaShape, *areas[0].AreaShape)

	assert.Equal(t, "area-2", areas[1].ID)
	assert.Equal(t, "エリアB", areas[1].Name)
	assert.Nil(t, areas[1].AreaShape)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllDetectionAreas_FilterByCameraID(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	cameraID := "camera-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "camera_id", "name", "area_shape", "created_at", "updated_at",
	}).
		AddRow("area-1", cameraID, "エリアA", nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 AND camera_id = (.+) ORDER BY name").
		WithArgs(cameraID).
		WillReturnRows(rows)

	// Execute
	areas, err := GetAllDetectionAreas(db, &cameraID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, areas, 1)
	assert.Equal(t, "area-1", areas[0].ID)
	assert.Equal(t, cameraID, areas[0].CameraID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllDetectionAreas_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	rows := sqlmock.NewRows([]string{
		"id", "camera_id", "name", "area_shape", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 ORDER BY name").
		WillReturnRows(rows)

	// Execute
	areas, err := GetAllDetectionAreas(db, nil)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, areas)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllDetectionAreas_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 ORDER BY name").
		WillReturnError(sql.ErrConnDone)

	// Execute
	areas, err := GetAllDetectionAreas(db, nil)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, areas)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}
