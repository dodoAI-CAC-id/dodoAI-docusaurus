package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetVideosByIncidentID Tests ====================

func TestGetVideosByIncidentID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-1"
	now := time.Now()
	spanStart := now.Add(-10 * time.Minute)
	spanEnd := now.Add(-5 * time.Minute)
	thumbnailURL := "https://example.com/thumb.jpg"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	}).
		AddRow("video-1", incidentID, "https://example.com/video1.mp4", &thumbnailURL, true, &spanStart, &spanEnd, now).
		AddRow("video-2", incidentID, "https://example.com/video2.mp4", nil, false, nil, nil, now)

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	videos, err := GetVideosByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, videos, 2)
	assert.Equal(t, "video-1", videos[0].ID)
	assert.Equal(t, incidentID, videos[0].IncidentID)
	assert.Equal(t, "https://example.com/video1.mp4", videos[0].FileURL)
	assert.NotNil(t, videos[0].ThumbnailURL)
	assert.Equal(t, thumbnailURL, *videos[0].ThumbnailURL)
	assert.True(t, videos[0].Mosaic)
	assert.NotNil(t, videos[0].SpanStart)
	assert.NotNil(t, videos[0].SpanEnd)

	assert.Equal(t, "video-2", videos[1].ID)
	assert.Equal(t, "https://example.com/video2.mp4", videos[1].FileURL)
	assert.Nil(t, videos[1].ThumbnailURL)
	assert.False(t, videos[1].Mosaic)
	assert.Nil(t, videos[1].SpanStart)
	assert.Nil(t, videos[1].SpanEnd)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetVideosByIncidentID_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-no-videos"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	videos, err := GetVideosByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, videos)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetVideosByIncidentID_MultipleVideos(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-many-videos"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	})

	// Add 5 videos
	for i := 1; i <= 5; i++ {
		rows.AddRow(
			"video-"+string(rune('0'+i)),
			incidentID,
			"https://example.com/video.mp4",
			nil,
			false,
			nil,
			nil,
			now,
		)
	}

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	videos, err := GetVideosByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, videos, 5)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetVideosByIncidentID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-1"

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	videos, err := GetVideosByIncidentID(db, incidentID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, videos)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetVideoByID Tests ====================

func TestGetVideoByID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	videoID := "video-1"
	now := time.Now()
	spanStart := now.Add(-10 * time.Minute)
	spanEnd := now.Add(-5 * time.Minute)
	thumbnailURL := "https://example.com/thumb.jpg"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	}).
		AddRow(videoID, "incident-1", "https://example.com/video.mp4", &thumbnailURL, true, &spanStart, &spanEnd, now)

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE id = (.+)").
		WithArgs(videoID).
		WillReturnRows(rows)

	// Execute
	video, err := GetVideoByID(db, videoID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, video)
	assert.Equal(t, videoID, video.ID)
	assert.Equal(t, "incident-1", video.IncidentID)
	assert.Equal(t, "https://example.com/video.mp4", video.FileURL)
	assert.NotNil(t, video.ThumbnailURL)
	assert.Equal(t, thumbnailURL, *video.ThumbnailURL)
	assert.True(t, video.Mosaic)
	assert.NotNil(t, video.SpanStart)
	assert.NotNil(t, video.SpanEnd)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetVideoByID_WithMinimalFields(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	videoID := "video-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	}).
		AddRow(videoID, "incident-1", "https://example.com/video.mp4", nil, false, nil, nil, now)

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE id = (.+)").
		WithArgs(videoID).
		WillReturnRows(rows)

	// Execute
	video, err := GetVideoByID(db, videoID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, video)
	assert.Equal(t, videoID, video.ID)
	assert.Nil(t, video.ThumbnailURL)
	assert.False(t, video.Mosaic)
	assert.Nil(t, video.SpanStart)
	assert.Nil(t, video.SpanEnd)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetVideoByID_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	videoID := "non-existent-id"

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE id = (.+)").
		WithArgs(videoID).
		WillReturnError(sql.ErrNoRows)

	// Execute
	video, err := GetVideoByID(db, videoID)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, video)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetVideoByID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	videoID := "video-1"

	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE id = (.+)").
		WithArgs(videoID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	video, err := GetVideoByID(db, videoID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, video)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreateIncidentVideo Tests ====================

func TestCreateIncidentVideo_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-1"
	fileURL := "https://example.com/video.mp4"
	thumbnailURL := "https://example.com/thumb.jpg"
	mosaic := true
	now := time.Now()
	spanStart := now.Add(-10 * time.Minute)
	spanEnd := now.Add(-5 * time.Minute)

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	}).
		AddRow("new-video-id", incidentID, fileURL, &thumbnailURL, mosaic, &spanStart, &spanEnd, now)

	mock.ExpectQuery("INSERT INTO incident_videos (.+) RETURNING (.+)").
		WithArgs(incidentID, fileURL, &thumbnailURL, mosaic, &spanStart, &spanEnd).
		WillReturnRows(rows)

	// Execute
	video, err := CreateIncidentVideo(db, incidentID, fileURL, &thumbnailURL, mosaic, &spanStart, &spanEnd)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, video)
	assert.Equal(t, "new-video-id", video.ID)
	assert.Equal(t, incidentID, video.IncidentID)
	assert.Equal(t, fileURL, video.FileURL)
	assert.NotNil(t, video.ThumbnailURL)
	assert.Equal(t, thumbnailURL, *video.ThumbnailURL)
	assert.True(t, video.Mosaic)
	assert.NotNil(t, video.SpanStart)
	assert.NotNil(t, video.SpanEnd)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateIncidentVideo_MinimalFields(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-1"
	fileURL := "https://example.com/video.mp4"
	mosaic := false
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	}).
		AddRow("new-video-id", incidentID, fileURL, nil, mosaic, nil, nil, now)

	mock.ExpectQuery("INSERT INTO incident_videos (.+) RETURNING (.+)").
		WithArgs(incidentID, fileURL, nil, mosaic, nil, nil).
		WillReturnRows(rows)

	// Execute
	video, err := CreateIncidentVideo(db, incidentID, fileURL, nil, mosaic, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, video)
	assert.Equal(t, "new-video-id", video.ID)
	assert.Equal(t, incidentID, video.IncidentID)
	assert.Equal(t, fileURL, video.FileURL)
	assert.Nil(t, video.ThumbnailURL)
	assert.False(t, video.Mosaic)
	assert.Nil(t, video.SpanStart)
	assert.Nil(t, video.SpanEnd)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateIncidentVideo_WithMosaicTrue(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-1"
	fileURL := "https://example.com/video.mp4"
	mosaic := true
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at",
	}).
		AddRow("new-video-id", incidentID, fileURL, nil, mosaic, nil, nil, now)

	mock.ExpectQuery("INSERT INTO incident_videos (.+) RETURNING (.+)").
		WithArgs(incidentID, fileURL, nil, mosaic, nil, nil).
		WillReturnRows(rows)

	// Execute
	video, err := CreateIncidentVideo(db, incidentID, fileURL, nil, mosaic, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, video)
	assert.True(t, video.Mosaic)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateIncidentVideo_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-1"
	fileURL := "https://example.com/video.mp4"

	mock.ExpectQuery("INSERT INTO incident_videos (.+) RETURNING (.+)").
		WithArgs(incidentID, fileURL, nil, false, nil, nil).
		WillReturnError(sql.ErrConnDone)

	// Execute
	video, err := CreateIncidentVideo(db, incidentID, fileURL, nil, false, nil, nil)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, video)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}
