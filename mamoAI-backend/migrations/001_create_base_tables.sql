-- Migration 001: Create base tables for monitoring system
-- Created: 2025-10-29

-- ==========================================
-- CORE ENTITIES
-- ==========================================

-- Departments table
CREATE TABLE IF NOT EXISTS departments (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Staff table
CREATE TABLE IF NOT EXISTS staffs (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    name VARCHAR(100) NOT NULL,
    department_id VARCHAR(36) REFERENCES departments(id) ON DELETE SET NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'care',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Rooms table
CREATE TABLE IF NOT EXISTS rooms (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    room_number VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Persons table (監視対象者)
CREATE TABLE IF NOT EXISTS persons (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    name VARCHAR(100) NOT NULL,
    kana VARCHAR(100),
    birthday DATE,
    gender VARCHAR(20) DEFAULT 'unknown',
    room_id VARCHAR(36) REFERENCES rooms(id) ON DELETE SET NULL,
    memo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_gender CHECK (gender IN ('male', 'female', 'other', 'unknown'))
);

-- Camera Devices table
CREATE TABLE IF NOT EXISTS camera_devices (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    serial_number VARCHAR(100) NOT NULL UNIQUE,
    room_id VARCHAR(36) REFERENCES rooms(id) ON DELETE SET NULL,
    model VARCHAR(100),
    install_date DATE,
    status VARCHAR(20) DEFAULT 'normal',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_camera_status CHECK (status IN ('normal', 'error', 'maintenance'))
);

-- Detection Areas table
CREATE TABLE IF NOT EXISTS detection_areas (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    camera_id VARCHAR(36) NOT NULL REFERENCES camera_devices(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    area_shape TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- INCIDENT MANAGEMENT
-- ==========================================

-- Incidents table (異常イベント)
CREATE TABLE IF NOT EXISTS incidents (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    detected_at TIMESTAMP NOT NULL,
    type VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'open',
    person_id VARCHAR(36) REFERENCES persons(id) ON DELETE SET NULL,
    camera_id VARCHAR(36) REFERENCES camera_devices(id) ON DELETE SET NULL,
    room_id VARCHAR(36) REFERENCES rooms(id) ON DELETE SET NULL,
    detection_area_id VARCHAR(36) REFERENCES detection_areas(id) ON DELETE SET NULL,
    description TEXT,
    created_by VARCHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_incident_status CHECK (status IN ('open', 'resolved', 'monitoring'))
);

-- Incident Videos table
CREATE TABLE IF NOT EXISTS incident_videos (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    incident_id VARCHAR(36) NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    file_url TEXT NOT NULL,
    thumbnail_url TEXT,
    mosaic BOOLEAN DEFAULT FALSE,
    span_start TIMESTAMP,
    span_end TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- NOTIFICATION SYSTEM
-- ==========================================

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    incident_id VARCHAR(36) NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    sent_to_staff_ids TEXT[] NOT NULL,
    delivery_rule TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notification_type VARCHAR(50),
    action_required BOOLEAN DEFAULT FALSE,
    unread_by_staff_ids TEXT[] DEFAULT '{}',
    escalated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notification Histories table
CREATE TABLE IF NOT EXISTS notification_histories (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    notification_id VARCHAR(36) NOT NULL REFERENCES notifications(id) ON DELETE CASCADE,
    staff_id VARCHAR(36) NOT NULL,
    read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    escalated BOOLEAN DEFAULT FALSE,
    escalated_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- ACTION MANAGEMENT
-- ==========================================

-- Actions table (対応履歴)
CREATE TABLE IF NOT EXISTS actions (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    incident_id VARCHAR(36) NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    staff_id VARCHAR(36) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    progress VARCHAR(20) DEFAULT 'in_progress',
    start_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_at TIMESTAMP,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_action_progress CHECK (progress IN ('in_progress', 'completed', 'monitoring'))
);

-- ==========================================
-- AUDIT & CONFIGURATION
-- ==========================================

-- Audit Logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    operation VARCHAR(50) NOT NULL,
    operator_id VARCHAR(36),
    target_type VARCHAR(50),
    target_id VARCHAR(36),
    detail TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Configurations table
CREATE TABLE IF NOT EXISTS configurations (
    id VARCHAR(36) PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    ai_sensitivity INTEGER DEFAULT 50,
    video_retention_days INTEGER DEFAULT 30,
    notification_rules JSONB,
    notification_timeout_sec INTEGER DEFAULT 300,
    camera_on_off_config JSONB,
    area_config JSONB,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(36)
);

-- Insert default configuration
INSERT INTO configurations (ai_sensitivity, video_retention_days, notification_timeout_sec)
VALUES (50, 30, 300)
ON CONFLICT DO NOTHING;

-- ==========================================
-- INDEXES FOR PERFORMANCE
-- ==========================================

-- Incident indexes
CREATE INDEX IF NOT EXISTS idx_incidents_person_id ON incidents(person_id);
CREATE INDEX IF NOT EXISTS idx_incidents_camera_id ON incidents(camera_id);
CREATE INDEX IF NOT EXISTS idx_incidents_room_id ON incidents(room_id);
CREATE INDEX IF NOT EXISTS idx_incidents_detected_at ON incidents(detected_at DESC);
CREATE INDEX IF NOT EXISTS idx_incidents_status ON incidents(status);
CREATE INDEX IF NOT EXISTS idx_incidents_type ON incidents(type);

-- Notification indexes
CREATE INDEX IF NOT EXISTS idx_notifications_incident_id ON notifications(incident_id);
CREATE INDEX IF NOT EXISTS idx_notifications_sent_at ON notifications(sent_at DESC);

-- Action indexes
CREATE INDEX IF NOT EXISTS idx_actions_incident_id ON actions(incident_id);
CREATE INDEX IF NOT EXISTS idx_actions_staff_id ON actions(staff_id);
CREATE INDEX IF NOT EXISTS idx_actions_created_at ON actions(created_at DESC);

-- Audit log indexes
CREATE INDEX IF NOT EXISTS idx_audit_logs_operator_id ON audit_logs(operator_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_target_type ON audit_logs(target_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_operation ON audit_logs(operation);

-- Staff indexes
CREATE INDEX IF NOT EXISTS idx_staffs_department_id ON staffs(department_id);
CREATE INDEX IF NOT EXISTS idx_staffs_role ON staffs(role);

-- Person indexes
CREATE INDEX IF NOT EXISTS idx_persons_room_id ON persons(room_id);
CREATE INDEX IF NOT EXISTS idx_persons_name ON persons(name);

-- Camera indexes
CREATE INDEX IF NOT EXISTS idx_camera_devices_room_id ON camera_devices(room_id);
CREATE INDEX IF NOT EXISTS idx_camera_devices_status ON camera_devices(status);

-- Detection area indexes
CREATE INDEX IF NOT EXISTS idx_detection_areas_camera_id ON detection_areas(camera_id);

-- Notification history indexes
CREATE INDEX IF NOT EXISTS idx_notification_histories_notification_id ON notification_histories(notification_id);
CREATE INDEX IF NOT EXISTS idx_notification_histories_staff_id ON notification_histories(staff_id);
CREATE INDEX IF NOT EXISTS idx_notification_histories_read ON notification_histories(read);

-- Incident video indexes
CREATE INDEX IF NOT EXISTS idx_incident_videos_incident_id ON incident_videos(incident_id);

-- ==========================================
-- TRIGGERS FOR UPDATED_AT
-- ==========================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_staffs_updated_at BEFORE UPDATE ON staffs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_rooms_updated_at BEFORE UPDATE ON rooms FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_persons_updated_at BEFORE UPDATE ON persons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_camera_devices_updated_at BEFORE UPDATE ON camera_devices FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_detection_areas_updated_at BEFORE UPDATE ON detection_areas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_incidents_updated_at BEFORE UPDATE ON incidents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- SAMPLE DATA FOR TESTING
-- ==========================================

-- Insert sample departments
INSERT INTO departments (id, name) VALUES
    ('dept-001', '介護部'),
    ('dept-002', '看護部'),
    ('dept-003', '管理部')
ON CONFLICT (name) DO NOTHING;

-- Insert sample staff
INSERT INTO staffs (id, name, department_id, role) VALUES
    ('staff-001', '山田太郎', 'dept-001', 'care'),
    ('staff-002', '佐藤花子', 'dept-001', 'care'),
    ('staff-003', '鈴木一郎', 'dept-002', 'nurse'),
    ('staff-004', '田中美咲', 'dept-003', 'admin')
ON CONFLICT DO NOTHING;

-- Insert sample rooms
INSERT INTO rooms (id, room_number, description) VALUES
    ('room-001', '101', '1階個室'),
    ('room-002', '102', '1階個室'),
    ('room-003', '201', '2階個室'),
    ('room-004', '202', '2階個室')
ON CONFLICT (room_number) DO NOTHING;

-- Insert sample persons
INSERT INTO persons (id, name, kana, birthday, gender, room_id) VALUES
    ('person-001', '山田太郎', 'ヤマダタロウ', '1940-05-15', 'male', 'room-001'),
    ('person-002', '佐藤花子', 'サトウハナコ', '1945-08-20', 'female', 'room-002'),
    ('person-003', '鈴木一郎', 'スズキイチロウ', '1938-12-10', 'male', 'room-003')
ON CONFLICT DO NOTHING;

-- Insert sample cameras
INSERT INTO camera_devices (id, serial_number, room_id, model, install_date, status) VALUES
    ('camera-001', 'CAM-2024-001', 'room-001', 'AI-CAM-PRO-X', '2024-01-15', 'normal'),
    ('camera-002', 'CAM-2024-002', 'room-002', 'AI-CAM-PRO-X', '2024-01-15', 'normal'),
    ('camera-003', 'CAM-2024-003', 'room-003', 'AI-CAM-PRO-X', '2024-01-16', 'normal'),
    ('camera-004', 'CAM-2024-004', 'room-004', 'AI-CAM-PRO-X', '2024-01-16', 'maintenance')
ON CONFLICT (serial_number) DO NOTHING;

-- Insert sample detection areas
INSERT INTO detection_areas (id, camera_id, name, area_shape) VALUES
    ('area-001', 'camera-001', 'ベッド周辺', '{"type":"polygon","coordinates":[[0,0],[100,0],[100,100],[0,100]]}'),
    ('area-002', 'camera-001', 'トイレ周辺', '{"type":"polygon","coordinates":[[100,0],[200,0],[200,100],[100,100]]}'),
    ('area-003', 'camera-002', 'ベッド周辺', '{"type":"polygon","coordinates":[[0,0],[100,0],[100,100],[0,100]]}')
ON CONFLICT DO NOTHING;

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
