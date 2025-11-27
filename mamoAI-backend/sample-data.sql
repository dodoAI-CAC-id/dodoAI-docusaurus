-- サンプルデータ投入スクリプト
-- 履歴画面のテスト用データを生成します

-- 1. 部署データ
INSERT INTO departments (id, name) VALUES
('dept-001', '介護部'),
('dept-002', '看護部'),
('dept-003', '管理部')
ON CONFLICT (id) DO NOTHING;

-- 2. スタッフデータ
INSERT INTO staffs (id, name, department_id, role) VALUES
('staff-001', '山田太郎', 'dept-001', 'care'),
('staff-002', '佐藤花子', 'dept-001', 'care'),
('staff-003', '田中一郎', 'dept-002', 'nurse'),
('staff-004', '鈴木次郎', 'dept-002', 'nurse'),
('staff-005', '高橋三郎', 'dept-003', 'admin')
ON CONFLICT (id) DO NOTHING;

-- 3. 居室データ
INSERT INTO rooms (id, room_number, description) VALUES
('room-001', '101', '個室A'),
('room-002', '102', '個室B'),
('room-003', '201', '多床室1'),
('room-004', '202', '多床室2')
ON CONFLICT (id) DO NOTHING;

-- 4. 対象者データ
INSERT INTO persons (id, name, kana, birthday, gender, room_id, memo) VALUES
('person-001', '高齢太郎', 'コウレイタロウ', '1940-01-15', 'male', 'room-001', '要介護3'),
('person-002', '高齢花子', 'コウレイハナコ', '1945-03-22', 'female', 'room-002', '要介護2'),
('person-003', '高齢一郎', 'コウレイイチロウ', '1938-06-10', 'male', 'room-003', '要介護4'),
('person-004', '高齢二郎', 'コウレイジロウ', '1942-09-05', 'male', 'room-004', '要介護3')
ON CONFLICT (id) DO NOTHING;

-- 5. カメラデバイスデータ
INSERT INTO camera_devices (id, serial_number, room_id, model, install_date, status) VALUES
('camera-001', 'CAM-2024-001', 'room-001', 'HD-CAM-PRO', '2024-01-10', 'normal'),
('camera-002', 'CAM-2024-002', 'room-002', 'HD-CAM-PRO', '2024-01-10', 'normal'),
('camera-003', 'CAM-2024-003', 'room-003', 'HD-CAM-PLUS', '2024-01-15', 'normal'),
('camera-004', 'CAM-2024-004', 'room-004', 'HD-CAM-PLUS', '2024-01-15', 'normal')
ON CONFLICT (id) DO NOTHING;

-- 6. 検知エリアデータ
INSERT INTO detection_areas (id, camera_id, name, area_shape) VALUES
('area-001', 'camera-001', 'ベッド周辺', '{"type":"polygon","coordinates":[[0,0],[100,0],[100,100],[0,100]]}'),
('area-002', 'camera-002', 'ベッド周辺', '{"type":"polygon","coordinates":[[0,0],[100,0],[100,100],[0,100]]}'),
('area-003', 'camera-003', 'ベッドA周辺', '{"type":"polygon","coordinates":[[0,0],[50,0],[50,100],[0,100]]}'),
('area-004', 'camera-003', 'ベッドB周辺', '{"type":"polygon","coordinates":[[50,0],[100,0],[100,100],[50,100]]}')
ON CONFLICT (id) DO NOTHING;

-- 7. インシデントデータ（過去7日分）
INSERT INTO incidents (id, detected_at, type, status, person_id, camera_id, room_id, detection_area_id, description) VALUES
-- 今日
('incident-001', NOW() - INTERVAL '2 hours', 'fall', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', '転倒検知 - 対応完了'),
('incident-002', NOW() - INTERVAL '5 hours', 'bed_exit', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', '離床検知 - 対応完了'),

-- 昨日
('incident-003', NOW() - INTERVAL '1 day' - INTERVAL '3 hours', 'fall', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', '転倒検知 - 対応完了'),
('incident-004', NOW() - INTERVAL '1 day' - INTERVAL '8 hours', 'bed_exit', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', '離床検知 - 対応完了'),

-- 2日前
('incident-005', NOW() - INTERVAL '2 days' - INTERVAL '2 hours', 'sitting', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', '端坐位検知 - 対応完了'),
('incident-006', NOW() - INTERVAL '2 days' - INTERVAL '6 hours', 'fall', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', '転倒検知 - 対応完了'),

-- 3日前
('incident-007', NOW() - INTERVAL '3 days' - INTERVAL '4 hours', 'bed_exit', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', '離床検知 - 対応完了'),
('incident-008', NOW() - INTERVAL '3 days' - INTERVAL '7 hours', 'sitting', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', '端坐位検知 - 対応完了'),

-- 4日前
('incident-009', NOW() - INTERVAL '4 days' - INTERVAL '1 hour', 'fall', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', '転倒検知 - 対応完了'),
('incident-010', NOW() - INTERVAL '4 days' - INTERVAL '9 hours', 'bed_exit', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', '離床検知 - 対応完了'),

-- 5日前
('incident-011', NOW() - INTERVAL '5 days' - INTERVAL '3 hours', 'sitting', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', '端坐位検知 - 対応完了'),
('incident-012', NOW() - INTERVAL '5 days' - INTERVAL '5 hours', 'fall', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', '転倒検知 - 対応完了'),

-- 6日前
('incident-013', NOW() - INTERVAL '6 days' - INTERVAL '2 hours', 'bed_exit', 'resolved', 'person-001', 'camera-001', 'room-001', 'area-001', '離床検知 - 対応完了'),
('incident-014', NOW() - INTERVAL '6 days' - INTERVAL '8 hours', 'sitting', 'resolved', 'person-002', 'camera-002', 'room-002', 'area-002', '端坐位検知 - 対応完了'),

-- 7日前
('incident-015', NOW() - INTERVAL '7 days' - INTERVAL '1 hour', 'fall', 'resolved', 'person-003', 'camera-003', 'room-003', 'area-003', '転倒検知 - 対応完了'),
('incident-016', NOW() - INTERVAL '7 days' - INTERVAL '6 hours', 'bed_exit', 'resolved', 'person-004', 'camera-004', 'room-004', 'area-004', '離床検知 - 対応完了'),

-- 進行中のインシデント
('incident-017', NOW() - INTERVAL '30 minutes', 'fall', 'monitoring', 'person-001', 'camera-001', 'room-001', 'area-001', '転倒検知 - 対応中'),
('incident-018', NOW() - INTERVAL '15 minutes', 'bed_exit', 'open', 'person-002', 'camera-002', 'room-002', 'area-002', '離床検知 - 未対応')
ON CONFLICT (id) DO NOTHING;

-- 8. アクションデータ（対応履歴）
INSERT INTO actions (id, incident_id, staff_id, action_type, progress, start_at, end_at, note) VALUES
-- incident-001 の対応履歴
('action-001', 'incident-001', 'staff-001', 'start', 'completed', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 hour 50 minutes', '現場確認開始'),
('action-002', 'incident-001', 'staff-001', 'complete', 'completed', NOW() - INTERVAL '1 hour 50 minutes', NOW() - INTERVAL '1 hour 45 minutes', '対応完了 - 異常なし'),

-- incident-002 の対応履歴
('action-003', 'incident-002', 'staff-002', 'start', 'completed', NOW() - INTERVAL '5 hours', NOW() - INTERVAL '4 hours 50 minutes', '現場確認開始'),
('action-004', 'incident-002', 'staff-002', 'complete', 'completed', NOW() - INTERVAL '4 hours 50 minutes', NOW() - INTERVAL '4 hours 45 minutes', '対応完了 - トイレ誘導実施'),

-- incident-003 の対応履歴
('action-005', 'incident-003', 'staff-003', 'start', 'completed', NOW() - INTERVAL '1 day' - INTERVAL '3 hours', NOW() - INTERVAL '1 day' - INTERVAL '2 hours 50 minutes', '現場確認開始'),
('action-006', 'incident-003', 'staff-003', 'complete', 'completed', NOW() - INTERVAL '1 day' - INTERVAL '2 hours 50 minutes', NOW() - INTERVAL '1 day' - INTERVAL '2 hours 45 minutes', '対応完了'),

-- incident-017 の対応履歴（進行中）
('action-007', 'incident-017', 'staff-001', 'start', 'in_progress', NOW() - INTERVAL '25 minutes', NULL, '現場に向かっています')
ON CONFLICT (id) DO NOTHING;

-- 9. 通知データ
INSERT INTO notifications (id, incident_id, sent_to_staff_ids, notification_type, action_required, unread_by_staff_ids, escalated) VALUES
('notif-001', 'incident-001', ARRAY['staff-001', 'staff-002'], 'incident_detected', true, ARRAY[]::text[], false),
('notif-002', 'incident-002', ARRAY['staff-002', 'staff-003'], 'incident_detected', true, ARRAY[]::text[], false),
('notif-003', 'incident-017', ARRAY['staff-001', 'staff-002'], 'incident_detected', true, ARRAY['staff-002'], false),
('notif-004', 'incident-018', ARRAY['staff-001', 'staff-002', 'staff-003'], 'incident_detected', true, ARRAY['staff-001', 'staff-002', 'staff-003'], false)
ON CONFLICT (id) DO NOTHING;

-- 10. 通知履歴データ
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

-- 11. システム設定データ
INSERT INTO configurations (id, ai_sensitivity, video_retention_days, notification_timeout_sec) VALUES
('config-001', 75, 30, 300)
ON CONFLICT (id) DO UPDATE SET
    ai_sensitivity = EXCLUDED.ai_sensitivity,
    video_retention_days = EXCLUDED.video_retention_days,
    notification_timeout_sec = EXCLUDED.notification_timeout_sec;

-- データ投入完了メッセージ
DO $$
BEGIN
    RAISE NOTICE 'Sample data insertion completed successfully!';
    RAISE NOTICE 'Incidents: 18 records';
    RAISE NOTICE 'Actions: 7 records';
    RAISE NOTICE 'Persons: 4 records';
    RAISE NOTICE 'Staffs: 5 records';
    RAISE NOTICE 'Rooms: 4 records';
END $$;
