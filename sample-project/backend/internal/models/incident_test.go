package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

func TestGetAllIncidents_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	// Setup test data
	now := time.Now()
	rows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow("id-1", now, "fall", "open", "person-1", "camera-1",
			"room-1", "area-1", "Test incident 1", "user-1", now, now).
		AddRow("id-2", now, "wander", "resolved", "person-2", "camera-2",
			"room-2", "area-2", "Test incident 2", "user-2", now, now)

	// Expected query
	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE 1=1 ORDER BY detected_at DESC").
		WillReturnRows(rows)

	// Execute
	incidents, err := GetAllIncidents(db, nil, nil, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, incidents, 2)
	assert.Equal(t, "id-1", incidents[0].ID)
	assert.Equal(t, "fall", incidents[0].Type)
	assert.Equal(t, "id-2", incidents[1].ID)
	assert.Equal(t, "wander", incidents[1].Type)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllIncidents_WithPersonIDFilter(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow("id-1", now, "fall", "open", "person-1", "camera-1",
			"room-1", "area-1", "Test incident", "user-1", now, now)

	// Expected query with personID filter
	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE 1=1 AND person_id = (.+) ORDER BY detected_at DESC").
		WithArgs(personID).
		WillReturnRows(rows)

	// Execute
	incidents, err := GetAllIncidents(db, &personID, nil, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, incidents, 1)
	assert.Equal(t, "person-1", *incidents[0].PersonID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllIncidents_WithStatusFilter(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	status := "resolved"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow("id-1", now, "fall", "resolved", "person-1", "camera-1",
			"room-1", "area-1", "Test incident", "user-1", now, now)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE 1=1 AND status = (.+) ORDER BY detected_at DESC").
		WithArgs(status).
		WillReturnRows(rows)

	// Execute
	incidents, err := GetAllIncidents(db, nil, &status, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, incidents, 1)
	assert.Equal(t, "resolved", incidents[0].Status)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllIncidents_WithTimeRangeFilter(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	from := time.Now().Add(-24 * time.Hour)
	to := time.Now()
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow("id-1", now, "fall", "open", "person-1", "camera-1",
			"room-1", "area-1", "Test incident", "user-1", now, now)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE 1=1 AND detected_at >= (.+) AND detected_at <= (.+) ORDER BY detected_at DESC").
		WithArgs(from, to).
		WillReturnRows(rows)

	// Execute
	incidents, err := GetAllIncidents(db, nil, nil, &from, &to)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, incidents, 1)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetIncidentByID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	now := time.Now()

	// Mock incident query
	incidentRows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow(incidentID, now, "fall", "open", "person-1", "camera-1",
			"room-1", "area-1", "Test incident", "user-1", now, now)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(incidentRows)

	// Mock related notifications query
	notificationRows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	})
	mock.ExpectQuery("SELECT (.+) FROM notifications WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(notificationRows)

	// Mock related actions query
	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "note", "created_at",
	})
	mock.ExpectQuery("SELECT (.+) FROM actions WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(actionRows)

	// Mock related videos query
	videoRows := sqlmock.NewRows([]string{
		"id", "incident_id", "camera_id", "video_url", "recorded_at",
		"duration", "file_size", "created_at",
	})
	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(videoRows)

	// Execute
	incident, err := GetIncidentByID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, incident)
	assert.Equal(t, incidentID, incident.ID)
	assert.Equal(t, "fall", incident.Type)
	assert.Equal(t, "open", incident.Status)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetIncidentByID_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "non-existent-id"

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE id = (.+)").
		WithArgs(incidentID).
		WillReturnError(sql.ErrNoRows)

	// Execute
	incident, err := GetIncidentByID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, incident)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateIncident_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	input := IncidentCreate{
		DetectedAt: time.Now(),
		Type:       "fall",
		PersonID:   "person-1",
		CameraID:   "camera-1",
	}

	now := time.Now()
	incidentID := "new-incident-id"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect incident insert
	incidentRows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow(incidentID, input.DetectedAt, input.Type, "open", input.PersonID, input.CameraID,
			nil, nil, nil, nil, now, now)

	mock.ExpectQuery("INSERT INTO incidents").
		WithArgs(input.DetectedAt, input.Type, input.PersonID, input.CameraID, nil, nil, nil).
		WillReturnRows(incidentRows)

	// Expect staff query for notifications
	staffRows := sqlmock.NewRows([]string{"id"}).
		AddRow("staff-1").
		AddRow("staff-2")
	mock.ExpectQuery("SELECT id FROM staffs WHERE role IN").
		WillReturnRows(staffRows)

	// Expect notification insert
	mock.ExpectExec("INSERT INTO notifications").
		WithArgs(incidentID, sqlmock.AnyArg()).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect notification history inserts
	mock.ExpectExec("INSERT INTO notification_histories").
		WithArgs("staff-1", incidentID).
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec("INSERT INTO notification_histories").
		WithArgs("staff-2", incidentID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect transaction commit
	mock.ExpectCommit()

	// Execute
	incident, err := CreateIncident(db, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, incident)
	assert.Equal(t, incidentID, incident.ID)
	assert.Equal(t, "fall", incident.Type)
	assert.Equal(t, "open", incident.Status)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateIncident_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	status := "resolved"
	description := "Updated description"

	input := IncidentUpdate{
		Status:      &status,
		Description: &description,
	}

	now := time.Now()

	// Expect update query
	updateRows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow(incidentID, now, "fall", status, "person-1", "camera-1",
			"room-1", "area-1", description, "user-1", now, now)

	mock.ExpectQuery("UPDATE incidents SET (.+) WHERE id = (.+)").
		WithArgs(status, description, incidentID).
		WillReturnRows(updateRows)

	// Execute
	incident, err := UpdateIncident(db, incidentID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, incident)
	assert.Equal(t, incidentID, incident.ID)
	assert.Equal(t, status, incident.Status)
	assert.Equal(t, description, *incident.Description)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateIncident_NoFieldsToUpdate(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	input := IncidentUpdate{}

	now := time.Now()

	// Expect GetIncidentByID query
	incidentRows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id",
		"room_id", "detection_area_id", "description", "created_by",
		"created_at", "updated_at",
	}).
		AddRow(incidentID, now, "fall", "open", "person-1", "camera-1",
			"room-1", "area-1", "Test incident", "user-1", now, now)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(incidentRows)

	// Mock related queries
	notificationRows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	})
	mock.ExpectQuery("SELECT (.+) FROM notifications WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(notificationRows)

	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "note", "created_at",
	})
	mock.ExpectQuery("SELECT (.+) FROM actions WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(actionRows)

	videoRows := sqlmock.NewRows([]string{
		"id", "incident_id", "camera_id", "video_url", "recorded_at",
		"duration", "file_size", "created_at",
	})
	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(videoRows)

	// Execute
	incident, err := UpdateIncident(db, incidentID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, incident)
	assert.Equal(t, incidentID, incident.ID)
	assert.NoError(t, mock.ExpectationsWereMet())
}
