-- ビュー画面用リセットシードデータ
-- 異常検知一覧: 5件（open=3件, monitoring=2件）
-- ご利用者一覧: 3件（resolved=3件）
-- 合計: 8件（部屋番号は重複なし）

-- 既存のactions/incidentsをクリア
TRUNCATE TABLE actions RESTART IDENTITY CASCADE;
TRUNCATE TABLE incidents RESTART IDENTITY CASCADE;

-- 必要な部屋データを確保（既存があればスキップ）
INSERT INTO rooms (id, room_number, created_at, updated_at) VALUES
('room-001', '101', NOW(), NOW()),
('room-002', '102', NOW(), NOW()),
('room-005', '103', NOW(), NOW()),
('room-006', '104', NOW(), NOW()),
('room-007', '105', NOW(), NOW()),
('room-008', '203', NOW(), NOW()),
('room-009', '204', NOW(), NOW()),
('room-010', '205', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 必要な見守り対象者データを確保
INSERT INTO persons (id, name, gender, room_id, created_at, updated_at) VALUES
('person-001', '山田太郎', 'male', 'room-001', NOW(), NOW()),
('person-002', '佐藤花子', 'female', 'room-002', NOW(), NOW()),
('person-003', '鈴木一郎', 'male', 'room-005', NOW(), NOW()),
('person-004', '田中美咲', 'female', 'room-006', NOW(), NOW()),
('person-005', '高橋健太', 'male', 'room-007', NOW(), NOW()),
('person-006', '伊藤さくら', 'female', 'room-008', NOW(), NOW()),
('person-007', '渡辺次郎', 'male', 'room-009', NOW(), NOW()),
('person-008', '中村美咲', 'female', 'room-010', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 固定8件のインシデントデータ
-- 異常検知一覧（5件）: open=3件, monitoring=2件
-- ご利用者一覧（3件）: resolved=3件
INSERT INTO incidents (id, detected_at, type, status, person_id, camera_id, room_id, description, created_at, updated_at) VALUES
-- 【異常検知一覧】未対応（open）3件
('incident-view-001', '2025-11-15T06:00:00Z', '転倒', 'open', 'person-001', 'camera-001', 'room-001', 'ベッドから転落', NOW(), NOW()),
('incident-view-002', '2025-11-15T06:15:00Z', '起床', 'open', 'person-002', 'camera-001', 'room-002', 'ベッドから起き上がり', NOW(), NOW()),
('incident-view-003', '2025-11-15T06:30:00Z', '離床', 'open', 'person-003', 'camera-002', 'room-005', 'ベッドから離れた', NOW(), NOW()),

-- 【異常検知一覧】対応中（monitoring）2件
('incident-view-004', '2025-11-15T06:45:00Z', '端坐位', 'monitoring', 'person-004', 'camera-002', 'room-006', 'ベッド端に座っている', NOW(), NOW()),
('incident-view-005', '2025-11-15T07:00:00Z', '徘徊', 'monitoring', 'person-005', 'camera-003', 'room-007', '廊下を徘徊中', NOW(), NOW()),

-- 【ご利用者一覧】対応済（resolved）3件
('incident-view-006', '2025-11-14T20:00:00Z', '転倒', 'resolved', 'person-006', 'camera-003', 'room-008', '対応完了', NOW(), NOW()),
('incident-view-007', '2025-11-14T21:00:00Z', '徘徊', 'resolved', 'person-007', 'camera-004', 'room-009', '対応完了', NOW(), NOW()),
('incident-view-008', '2025-11-14T22:00:00Z', '起床', 'resolved', 'person-008', 'camera-004', 'room-010', '対応完了', NOW(), NOW());

-- 対応中インシデント用のアクション（任意）
INSERT INTO actions (id, incident_id, staff_id, action_type, progress, start_at, note, created_at) VALUES
('action-view-001', 'incident-view-004', 'staff-001', 'start', 'in_progress', '2025-11-15T06:46:00Z', '対応開始', NOW()),
('action-view-002', 'incident-view-005', 'staff-001', 'start', 'in_progress', '2025-11-15T07:01:00Z', '対応開始', NOW());
