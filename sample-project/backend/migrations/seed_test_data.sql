-- テストデータ追加スクリプト
-- 多様な見守り対象者、部屋、スタッフ、異常イベントを追加

-- 1. 部屋を追加（既存: 101, 102, 201, 202）
INSERT INTO rooms (id, room_number, created_at, updated_at) VALUES
('room-005', '103', NOW(), NOW()),
('room-006', '104', NOW(), NOW()),
('room-007', '105', NOW(), NOW()),
('room-008', '203', NOW(), NOW()),
('room-009', '204', NOW(), NOW()),
('room-010', '205', NOW(), NOW()),
('room-011', '301', NOW(), NOW()),
('room-012', '302', NOW(), NOW()),
('room-013', '303', NOW(), NOW()),
('room-014', '304', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 2. 見守り対象者を追加
INSERT INTO persons (id, name, gender, room_id, created_at, updated_at) VALUES
('person-002', '佐藤花子', 'female', 'room-005', NOW(), NOW()),
('person-003', '田中健太', 'male', 'room-006', NOW(), NOW()),
('person-004', '鈴木次郎', 'male', 'room-007', NOW(), NOW()),
('person-005', '高橋美咲', 'female', 'room-008', NOW(), NOW()),
('person-006', '伊藤太郎', 'male', 'room-009', NOW(), NOW()),
('person-007', '渡辺花子', 'female', 'room-010', NOW(), NOW()),
('person-008', '中村次郎', 'male', 'room-011', NOW(), NOW()),
('person-009', '小林美咲', 'female', 'room-012', NOW(), NOW()),
('person-010', '加藤太郎', 'male', 'room-013', NOW(), NOW()),
('person-011', '吉田花子', 'female', 'room-014', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 3. スタッフを追加
INSERT INTO staffs (id, name, role, created_at, updated_at) VALUES
('staff-002', '鈴木一郎', '介護士', NOW(), NOW()),
('staff-003', '佐藤美咲', '看護師', NOW(), NOW()),
('staff-004', '田中太郎', '介護士', NOW(), NOW()),
('staff-005', '高橋健太', '看護師', NOW(), NOW()),
('staff-006', '伊藤花子', '介護士', NOW(), NOW()),
('staff-007', '渡辺次郎', '看護師', NOW(), NOW()),
('staff-008', '中村美咲', '介護士', NOW(), NOW()),
('staff-009', '小林太郎', '看護師', NOW(), NOW()),
('staff-010', '加藤花子', '介護士', NOW(), NOW()),
('staff-011', '吉田次郎', '看護師', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 4. カメラを追加（camerasテーブルが存在しない場合はスキップ）
-- INSERT INTO cameras (id, name, location, room_id, created_at, updated_at) VALUES
-- ('camera-002', 'カメラ102', '102号室', 'room-002', NOW(), NOW())
-- ON CONFLICT (id) DO NOTHING;

-- 5. 異常イベントを追加（多様な日時、種別）
-- status: 'open', 'resolved', 'monitoring' のみ許可
-- 既存カメラID: camera-001, camera-002, camera-003, camera-004 を使用
INSERT INTO incidents (id, detected_at, type, status, person_id, camera_id, room_id, description, created_at, updated_at) VALUES
-- 今日のイベント
('incident-002', '2025-11-07T09:15:00Z', '転倒', 'open', 'person-002', 'camera-001', 'room-005', 'ベッドから転落', NOW(), NOW()),
('incident-003', '2025-11-07T10:30:00Z', '徘徊', 'monitoring', 'person-003', 'camera-002', 'room-006', '廊下を徘徊中', NOW(), NOW()),
('incident-004', '2025-11-07T11:45:00Z', '転倒', 'resolved', 'person-004', 'camera-003', 'room-007', 'トイレで転倒', NOW(), NOW()),

-- 昨日のイベント
('incident-005', '2025-11-06T08:20:00Z', '徘徊', 'resolved', 'person-005', 'camera-004', 'room-008', '部屋を出て徘徊', NOW(), NOW()),
('incident-006', '2025-11-06T13:10:00Z', '転倒', 'open', 'person-006', 'camera-001', 'room-009', '椅子から転落', NOW(), NOW()),
('incident-007', '2025-11-06T15:30:00Z', '徘徊', 'monitoring', 'person-007', 'camera-002', 'room-010', '食堂で徘徊', NOW(), NOW()),

-- 一昨日のイベント
('incident-008', '2025-11-05T07:45:00Z', '転倒', 'resolved', 'person-008', 'camera-003', 'room-011', 'ベッド周辺で転倒', NOW(), NOW()),
('incident-009', '2025-11-05T12:20:00Z', '徘徊', 'resolved', 'person-009', 'camera-004', 'room-012', '廊下を徘徊', NOW(), NOW()),
('incident-010', '2025-11-05T16:50:00Z', '転倒', 'open', 'person-010', 'camera-001', 'room-013', '浴室で転倒', NOW(), NOW()),
('incident-011', '2025-11-05T19:30:00Z', '徘徊', 'monitoring', 'person-011', 'camera-002', 'room-014', '夜間徘徊', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 6. 対応アクションを追加（多様な操作タイプ）
INSERT INTO actions (id, incident_id, staff_id, action_type, progress, start_at, end_at, note, created_at) VALUES
-- incident-002: 転倒 - 対応開始
('action-002', 'incident-002', 'staff-002', 'start', 'in_progress', '2025-11-07T09:16:00Z', NULL, '現場に向かっています', NOW()),

-- incident-003: 徘徊 - 到着済み
('action-003', 'incident-003', 'staff-003', 'start', 'completed', '2025-11-07T10:31:00Z', '2025-11-07T10:32:00Z', '現場に向かいます', NOW()),
('action-004', 'incident-003', 'staff-003', 'arrived', 'in_progress', '2025-11-07T10:32:00Z', NULL, '現場到着、対応中', NOW()),

-- incident-004: 転倒 - 完了
('action-005', 'incident-004', 'staff-004', 'start', 'completed', '2025-11-07T11:46:00Z', '2025-11-07T11:47:00Z', '現場に向かいます', NOW()),
('action-006', 'incident-004', 'staff-004', 'arrived', 'completed', '2025-11-07T11:47:00Z', '2025-11-07T11:50:00Z', '現場到着、対応中', NOW()),
('action-007', 'incident-004', 'staff-004', 'completed', 'completed', '2025-11-07T11:50:00Z', '2025-11-07T11:50:00Z', '対応完了、異常なし', NOW()),

-- incident-005: 徘徊 - 完了
('action-008', 'incident-005', 'staff-005', 'start', 'completed', '2025-11-06T08:21:00Z', '2025-11-06T08:22:00Z', '現場に向かいます', NOW()),
('action-009', 'incident-005', 'staff-005', 'arrived', 'completed', '2025-11-06T08:22:00Z', '2025-11-06T08:25:00Z', '対応中', NOW()),
('action-010', 'incident-005', 'staff-005', 'completed', 'completed', '2025-11-06T08:25:00Z', '2025-11-06T08:25:00Z', '部屋に誘導完了', NOW()),

-- incident-006: 転倒 - 対応開始
('action-011', 'incident-006', 'staff-006', 'start', 'in_progress', '2025-11-06T13:11:00Z', NULL, '現場に向かっています', NOW()),

-- incident-007: 徘徊 - 到着済み
('action-012', 'incident-007', 'staff-007', 'start', 'completed', '2025-11-06T15:31:00Z', '2025-11-06T15:32:00Z', '現場に向かいます', NOW()),
('action-013', 'incident-007', 'staff-007', 'arrived', 'in_progress', '2025-11-06T15:32:00Z', NULL, '現場到着、対応中', NOW()),

-- incident-008: 転倒 - 完了
('action-014', 'incident-008', 'staff-008', 'start', 'completed', '2025-11-05T07:46:00Z', '2025-11-05T07:47:00Z', '現場に向かいます', NOW()),
('action-015', 'incident-008', 'staff-008', 'arrived', 'completed', '2025-11-05T07:47:00Z', '2025-11-05T07:52:00Z', '対応中', NOW()),
('action-016', 'incident-008', 'staff-008', 'completed', 'completed', '2025-11-05T07:52:00Z', '2025-11-05T07:52:00Z', '対応完了、医師に報告済み', NOW()),

-- incident-009: 徘徊 - 完了
('action-017', 'incident-009', 'staff-009', 'start', 'completed', '2025-11-05T12:21:00Z', '2025-11-05T12:22:00Z', '現場に向かいます', NOW()),
('action-018', 'incident-009', 'staff-009', 'arrived', 'completed', '2025-11-05T12:22:00Z', '2025-11-05T12:28:00Z', '対応中', NOW()),
('action-019', 'incident-009', 'staff-009', 'completed', 'completed', '2025-11-05T12:28:00Z', '2025-11-05T12:28:00Z', '部屋に誘導完了', NOW()),

-- incident-010: 転倒 - 対応開始
('action-020', 'incident-010', 'staff-010', 'start', 'in_progress', '2025-11-05T16:51:00Z', NULL, '現場に向かっています', NOW()),

-- incident-011: 徘徊 - 到着済み
('action-021', 'incident-011', 'staff-011', 'start', 'completed', '2025-11-05T19:31:00Z', '2025-11-05T19:32:00Z', '現場に向かいます', NOW()),
('action-022', 'incident-011', 'staff-011', 'arrived', 'in_progress', '2025-11-05T19:32:00Z', NULL, '現場到着、対応中', NOW())
ON CONFLICT (id) DO NOTHING;
