package models

import (
	"database/sql"
	"time"
)

// IncidentVideo represents a video recording of an incident
type IncidentVideo struct {
	ID           string     `json:"id"`
	IncidentID   string     `json:"incidentId"`
	FileURL      string     `json:"fileUrl"`
	ThumbnailURL *string    `json:"thumbnailUrl,omitempty"`
	Mosaic       bool       `json:"mosaic"`
	SpanStart    *time.Time `json:"spanStart,omitempty"`
	SpanEnd      *time.Time `json:"spanEnd,omitempty"`
	CreatedAt    time.Time  `json:"createdAt"`
}

// GetVideosByIncidentID retrieves all videos for an incident
func GetVideosByIncidentID(db *sql.DB, incidentID string) ([]IncidentVideo, error) {
	query := `
		SELECT id, incident_id, file_url, thumbnail_url, mosaic, span_start, span_end, created_at
		FROM incident_videos
		WHERE incident_id = $1
		ORDER BY created_at DESC
	`

	rows, err := db.Query(query, incidentID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var videos []IncidentVideo
	for rows.Next() {
		var video IncidentVideo
		err := rows.Scan(
			&video.ID,
			&video.IncidentID,
			&video.FileURL,
			&video.ThumbnailURL,
			&video.Mosaic,
			&video.SpanStart,
			&video.SpanEnd,
			&video.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
		videos = append(videos, video)
	}

	return videos, rows.Err()
}

// GetVideoByID retrieves a specific video by ID
func GetVideoByID(db *sql.DB, videoID string) (*IncidentVideo, error) {
	query := `
		SELECT id, incident_id, file_url, thumbnail_url, mosaic, span_start, span_end, created_at
		FROM incident_videos
		WHERE id = $1
	`

	var video IncidentVideo
	err := db.QueryRow(query, videoID).Scan(
		&video.ID,
		&video.IncidentID,
		&video.FileURL,
		&video.ThumbnailURL,
		&video.Mosaic,
		&video.SpanStart,
		&video.SpanEnd,
		&video.CreatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &video, nil
}

// CreateIncidentVideo creates a new video record for an incident
func CreateIncidentVideo(db *sql.DB, incidentID, fileURL string, thumbnailURL *string, mosaic bool, spanStart, spanEnd *time.Time) (*IncidentVideo, error) {
	query := `
		INSERT INTO incident_videos (incident_id, file_url, thumbnail_url, mosaic, span_start, span_end)
		VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING id, incident_id, file_url, thumbnail_url, mosaic, span_start, span_end, created_at
	`

	var video IncidentVideo
	err := db.QueryRow(
		query,
		incidentID,
		fileURL,
		thumbnailURL,
		mosaic,
		spanStart,
		spanEnd,
	).Scan(
		&video.ID,
		&video.IncidentID,
		&video.FileURL,
		&video.ThumbnailURL,
		&video.Mosaic,
		&video.SpanStart,
		&video.SpanEnd,
		&video.CreatedAt,
	)

	if err != nil {
		return nil, err
	}

	return &video, nil
}
