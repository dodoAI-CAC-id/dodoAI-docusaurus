package testhelpers

import (
	"sample-project/internal/models"
	"time"
)

// CreateTestIncident creates a test incident for testing purposes
func CreateTestIncident() models.Incident {
	personID := "test-person-id"
	cameraID := "test-camera-id"
	roomID := "test-room-id"
	detectionAreaID := "test-area-id"
	description := "Test incident description"
	createdBy := "test-user"

	return models.Incident{
		ID:              "test-incident-id",
		DetectedAt:      time.Now(),
		Type:            "fall",
		Status:          "open",
		PersonID:        &personID,
		CameraID:        &cameraID,
		RoomID:          &roomID,
		DetectionAreaID: &detectionAreaID,
		Description:     &description,
		CreatedBy:       &createdBy,
		CreatedAt:       time.Now(),
		UpdatedAt:       time.Now(),
	}
}

// CreateTestIncidentCreate creates test input for incident creation
func CreateTestIncidentCreate() models.IncidentCreate {
	roomID := "test-room-id"
	detectionAreaID := "test-area-id"
	description := "Test incident"

	return models.IncidentCreate{
		DetectedAt:      time.Now(),
		Type:            "fall",
		PersonID:        "test-person-id",
		CameraID:        "test-camera-id",
		RoomID:          &roomID,
		DetectionAreaID: &detectionAreaID,
		Description:     &description,
	}
}

// CreateTestPerson creates a test person for testing purposes
func CreateTestPerson() models.Person {
	roomID := "test-room-id"
	kana := "テストタロウ"
	memo := "Test memo"

	return models.Person{
		ID:        "test-person-id",
		Name:      "Test Person",
		Kana:      &kana,
		Gender:    "male",
		RoomID:    &roomID,
		Memo:      &memo,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}
}

// CreateTestStaff creates a test staff member for testing purposes
func CreateTestStaff() models.Staff {
	deptID := "test-dept-id"
	deptName := "Test Department"

	return models.Staff{
		ID:             "test-staff-id",
		Name:           "Test Staff",
		Role:           "nurse",
		DepartmentID:   &deptID,
		DepartmentName: &deptName,
		CreatedAt:      time.Now(),
		UpdatedAt:      time.Now(),
	}
}

// CreateTestNotification creates a test notification for testing purposes
func CreateTestNotification() models.Notification {
	notificationType := "incident_detected"
	sentToStaffIDs := []string{"staff-1", "staff-2"}
	unreadByStaffIDs := []string{"staff-1", "staff-2"}

	return models.Notification{
		ID:               "test-notification-id",
		IncidentID:       "test-incident-id",
		SentToStaffIDs:   sentToStaffIDs,
		NotificationType: &notificationType,
		ActionRequired:   true,
		UnreadByStaffIDs: unreadByStaffIDs,
		SentAt:           time.Now(),
		Escalated:        false,
	}
}

// CreateTestAction creates a test action for testing purposes
func CreateTestAction() models.Action {
	return models.Action{
		ID:         "test-action-id",
		IncidentID: "test-incident-id",
		StaffID:    "test-staff-id",
		ActionType: "start",
		Note:       StringPtr("Started handling the incident"),
		CreatedAt:  time.Now(),
	}
}

// StringPtr returns a pointer to a string
func StringPtr(s string) *string {
	return &s
}

// TimePtr returns a pointer to a time.Time
func TimePtr(t time.Time) *time.Time {
	return &t
}
