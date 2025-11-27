-- Sample data for testing (English version)
-- Simple incident data for history screen testing

-- Clear existing data
TRUNCATE TABLE notification_histories, notifications, actions, incident_videos, incidents, detection_areas, camera_devices, persons, rooms, staffs, departments CASCADE;

-- 1. Departments
INSERT INTO departments (id, name) VALUES
('dept-001', 'Care Department'),
('dept-002', 'Nursing Department'),
('dept-003', 'Admin Department')
ON CONFLICT (id) DO NOTHING;

-- 2. Staff
INSERT INTO staffs (id, name, department_id, role) VALUES
('staff-001', 'John Doe', 'dept-001', 'care'),
('staff-002', 'Jane Smith', 'dept-001', 'care'),
('staff-003', 'Bob Johnson', 'dept-002', 'nurse'),
('staff-004', 'Alice Williams', 'dept-002', 'nurse'),
('staff-005', 'Charlie Brown', 'dept-003', 'admin')
ON CONFLICT (id) DO NOTHING;

-- 3. Rooms
INSERT INTO rooms (id, room_number, description) VALUES
('room-001', '101', 'Private Room A'),
('room-002', '102', 'Private Room B'),
('room-003', '201', 'Shared Room 1'),
('room-004', '202', 'Shared Room 2')
ON CONFLICT (id) DO NOTHING;

-- 4. Persons
INSERT INTO persons (id, name, kana, birthday, gender, room_id, memo) VALUES
('person-001', 'Taro Elderly', 'Taro', '1940-01-15', 'male', 'room-001', 'Care Level 3'),
('person-002', 'Hanako Elderly', 'Hanako', '1945-03-22', 'female', 'room-002', 'Care Level 2'),
('person-003', 'Ichiro Elderly', 'Ichiro', '1938-06-10', 'male', 'room-003', 'Care Level 4'),
('person-004', 'Jiro Elderly', 'Jiro', '1942-09-05', 'male', 'room-004', 'Care Level 3')
ON CONFLICT (id) DO NOTHING;

-- 5. Camera Devices
INSERT INTO camera_devices (id, serial_number, room_id, model, install_date, status) VALUES
('camera-001', 'CAM-2024-001', 'room-001', 'HD-CAM-PRO', '2024-01-10', 'normal'),
('camera-002', 'CAM-2024-002', 'room-002', 'HD-CAM-PRO', '2024-01-10', 'normal'),
('camera-003', 'CAM-2024-003', 'room-003', 'HD-CAM-PLUS', '2024-01-15', 'normal'),
('camera-004', 'CAM-2024-004', 'room-004', 'HD-CAM-PLUS', '2024-01-15', 'normal')
ON CONFLICT (id) DO NOTHING;

-- 6. Detection Areas
INSERT INTO detection_areas (id, camera_id, name, area_shape) VALUES
('area-001', 'camera-001', 'Bed Area', '{"type":"polygon","coordinates":[[0,0],[100,0],[100,100],[0,100]]}'),
('area-002', 'camera-002', 'Bed Area', '{"type":"polygon","coordinates":[[0,0],[100,0],[100,100],[0,100]]}'),
('area-003', 'camera-003', 'Bed A Area', '{"type":"polygon","coordinates":[[0,0],[50,0],[50,100],[0,100]]}'),
('area-004', 'camera-003', 'Bed B Area', '{"type":"polygon","coordinates":[[50,0],[100,0],[100,100],[50,100]]}')
ON CONFLICT (id) DO NOTHING;

-- 7. Incidents (Past 7 days)
INSERT INTO incidents (id, detected_at, type, status, person_id, camera_id, room_id, detection_area_id, description) VALUES
-- Today
('incident-001', NOW() - INTERVAL '2 hours', 'fall', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', 'Fall detected - Resolved'),
('incident-002', NOW() - INTERVAL '5 hours', 'bed_exit', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', 'Bed exit detected - Resolved'),
-- Yesterday
('incident-003', NOW() - INTERVAL '1 day' - INTERVAL '3 hours', 'fall', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', 'Fall detected - Resolved'),
('incident-004', NOW() - INTERVAL '1 day' - INTERVAL '8 hours', 'bed_exit', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', 'Bed exit detected - Resolved'),
-- 2 days ago
('incident-005', NOW() - INTERVAL '2 days' - INTERVAL '2 hours', 'sitting', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', 'Sitting position detected - Resolved'),
('incident-006', NOW() - INTERVAL '2 days' - INTERVAL '6 hours', 'fall', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', 'Fall detected - Resolved'),
-- 3 days ago
('incident-007', NOW() - INTERVAL '3 days' - INTERVAL '4 hours', 'bed_exit', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', 'Bed exit detected - Resolved'),
('incident-008', NOW() - INTERVAL '3 days' - INTERVAL '7 hours', 'sitting', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', 'Sitting position detected - Resolved'),
-- 4 days ago
('incident-009', NOW() - INTERVAL '4 days' - INTERVAL '1 hour', 'fall', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', 'Fall detected - Resolved'),
('incident-010', NOW() - INTERVAL '4 days' - INTERVAL '9 hours', 'bed_exit', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', 'Bed exit detected - Resolved'),
-- 5 days ago
('incident-011', NOW() - INTERVAL '5 days' - INTERVAL '3 hours', 'sitting', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', 'Sitting position detected - Resolved'),
('incident-012', NOW() - INTERVAL '5 days' - INTERVAL '5 hours', 'fall', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', 'Fall detected - Resolved'),
-- 6 days ago
('incident-013', NOW() - INTERVAL '6 days' - INTERVAL '2 hours', 'bed_exit', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', 'Bed exit detected - Resolved'),
('incident-014', NOW() - INTERVAL '6 days' - INTERVAL '8 hours', 'sitting', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', 'Sitting position detected - Resolved'),
-- 7 days ago
('incident-015', NOW() - INTERVAL '7 days' - INTERVAL '1 hour', 'fall', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', 'Fall detected - Resolved'),
('incident-016', NOW() - INTERVAL '7 days' - INTERVAL '6 hours', 'bed_exit', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', 'Bed exit detected - Resolved'),
-- In progress
('incident-017', NOW() - INTERVAL '30 minutes', 'fall', 'monitoring', 'person-001', 'camera-001', 'room-001', 'area-001', 'Fall detected - In progress'),
('incident-018', NOW() - INTERVAL '15 minutes', 'bed_exit', 'open', 'person-002', 'camera-002', 'room-002', 'area-002', 'Bed exit detected - Not responded')
ON CONFLICT (id) DO NOTHING;

-- 8. Actions
INSERT INTO actions (id, incident_id, staff_id, action_type, progress, start_at, end_at, note) VALUES
('action-001', 'incident-001', 'staff-001', 'start', 'completed', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 hour 50 minutes', 'Started on-site check'),
('action-002', 'incident-001', 'staff-001', 'complete', 'completed', NOW() - INTERVAL '1 hour 50 minutes', NOW() - INTERVAL '1 hour 45 minutes', 'Completed - No issues'),
('action-003', 'incident-002', 'staff-002', 'start', 'completed', NOW() - INTERVAL '5 hours', NOW() - INTERVAL '4 hours 50 minutes', 'Started on-site check'),
('action-004', 'incident-002', 'staff-002', 'complete', 'completed', NOW() - INTERVAL '4 hours 50 minutes', NOW() - INTERVAL '4 hours 45 minutes', 'Completed - Assisted to restroom'),
('action-005', 'incident-003', 'staff-003', 'start', 'completed', NOW() - INTERVAL '1 day' - INTERVAL '3 hours', NOW() - INTERVAL '1 day' - INTERVAL '2 hours 50 minutes', 'Started on-site check'),
('action-006', 'incident-003', 'staff-003', 'complete', 'completed', NOW() - INTERVAL '1 day' - INTERVAL '2 hours 50 minutes', NOW() - INTERVAL '1 day' - INTERVAL '2 hours 45 minutes', 'Completed'),
('action-007', 'incident-017', 'staff-001', 'start', 'in_progress', NOW() - INTERVAL '25 minutes', NULL, 'On the way to site')
ON CONFLICT (id) DO NOTHING;

-- 9. Notifications
INSERT INTO notifications (id, incident_id, sent_to_staff_ids, notification_type, action_required, unread_by_staff_ids, escalated) VALUES
('notif-001', 'incident-001', ARRAY['staff-001', 'staff-002'], 'incident_detected', true, ARRAY[]::text[], false),
('notif-002', 'incident-002', ARRAY['staff-002', 'staff-003'], 'incident_detected', true, ARRAY[]::text[], false),
('notif-003', 'incident-017', ARRAY['staff-001', 'staff-002'], 'incident_detected', true, ARRAY['staff-002'], false),
('notif-004', 'incident-018', ARRAY['staff-001', 'staff-002', 'staff-003'], 'incident_detected', true, ARRAY['staff-001', 'staff-002', 'staff-003'], false)
ON CONFLICT (id) DO NOTHING;

-- 10. Notification Histories
INSERT INTO notification_histories (id, notification_id, staff_id, read, read_at) VALUES
('nothist-001', 'notif-001', 'staff-001', true, NOW() - INTERVAL '1 hour 55 minutes'),
('nothist-002', 'notif-001', 'staff-002', true, NOW() - INTERVAL '1 hour 58 minutes'),
('nothist-003', 'notif-002', 'staff-002', true, NOW() - INTERVAL '4 hours 55 minutes'),
('nothist-004', 'notif-002', 'staff-003', true, NOW() - INTERVAL '4 hours 57 minutes'),
('nothist-005', 'notif-003', 'staff-001', true, NOW() - INTERVAL '28 minutes'),
('nothist-006', 'notif-003', 'staff-002', false, NULL),
('nothist-007', 'notif-004', 'staff-001', false, NULL),
('nothist-008', 'notif-004', 'staff-002', false, NULL),
('nothist-009', 'notif-004', 'staff-003', false, NULL)
ON CONFLICT (id) DO NOTHING;

-- 11. System Configuration
INSERT INTO configurations (id, ai_sensitivity, video_retention_days, notification_timeout_sec) VALUES
('config-001', 75, 30, 300)
ON CONFLICT (id) DO UPDATE SET
    ai_sensitivity = EXCLUDED.ai_sensitivity,
    video_retention_days = EXCLUDED.video_retention_days,
    notification_timeout_sec = EXCLUDED.notification_timeout_sec;

-- Display results
SELECT 'Data insertion completed!' AS status;
SELECT COUNT(*) AS incidents_count FROM incidents;
SELECT COUNT(*) AS actions_count FROM actions;
SELECT COUNT(*) AS persons_count FROM persons;
SELECT COUNT(*) AS staffs_count FROM staffs;
SELECT COUNT(*) AS rooms_count FROM rooms;
