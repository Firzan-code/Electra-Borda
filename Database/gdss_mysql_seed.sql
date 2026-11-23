-- GDSS ELECTRE–Borda: data seed deterministik untuk skenario demo-v1.
-- Sumber data: data/demo.json.
-- Hanya untuk database yang belum memiliki skenario demo-v1; tidak menghapus data.

USE gdss_electre_borda;
SET NAMES utf8mb4;

START TRANSACTION;

INSERT INTO scenarios (id, name, data_kind, description)
VALUES
    ('demo-v1', CONVERT(0x50656D696C6968616E20706C6174666F726D20414920E280942073696D756C61736920616B6164656D696B USING utf8mb4), 'dummy',
     CONVERT(0x444154412044554D4D59202F2053494D554C41534920E280942064696275617420756E74756B2064656D6F6E737472617369206D65746F646520454C454354524520492064616E20426F7264613B2062756B616E2073757276656920617461752062656E63686D61726B20706C6174666F726D2041492E USING utf8mb4));

INSERT INTO alternatives (scenario_id, code, name, description) VALUES
    ('demo-v1', 'A1', 'ChatGPT', NULL),
    ('demo-v1', 'A2', 'Gemini', NULL),
    ('demo-v1', 'A3', 'Claude', NULL),
    ('demo-v1', 'A4', 'Perplexity', NULL);

INSERT INTO criteria (scenario_id, code, name, type, min_val, max_val, unit) VALUES
    ('demo-v1', 'C1', 'Ketepatan isi', 'benefit', 1.00, 5.00, 'skor'),
    ('demo-v1', 'C2', 'Relevansi respons', 'benefit', 1.00, 5.00, 'skor'),
    ('demo-v1', 'C3', 'Keterlacakan referensi', 'benefit', 1.00, 5.00, 'skor'),
    ('demo-v1', 'C4', 'Kemudahan penggunaan', 'benefit', 1.00, 5.00, 'skor'),
    ('demo-v1', 'C5', 'Kecukupan akses', 'benefit', 1.00, 5.00, 'skor'),
    ('demo-v1', 'C6', 'Waktu penyelesaian', 'cost', 1.00, 60.00, 'menit simulasi');

INSERT INTO decision_makers (scenario_id, code, name) VALUES
    ('demo-v1', 'DM01', 'Penilai simulasi 01'),
    ('demo-v1', 'DM02', 'Penilai simulasi 02'),
    ('demo-v1', 'DM03', 'Penilai simulasi 03');

-- Bobot mentah per DM dan kriteria; trigger memastikan semua entitas satu skenario.
INSERT INTO criteria_weights (dm_id, criteria_id, weight)
SELECT dm.id, c.id, v.weight
FROM (
    SELECT 'DM01' AS dm_code, 'C1' AS criteria_code, 30.0000 AS weight
    UNION ALL SELECT 'DM01' AS dm_code, 'C2' AS criteria_code, 20.0000 AS weight
    UNION ALL SELECT 'DM01' AS dm_code, 'C3' AS criteria_code, 15.0000 AS weight
    UNION ALL SELECT 'DM01' AS dm_code, 'C4' AS criteria_code, 10.0000 AS weight
    UNION ALL SELECT 'DM01' AS dm_code, 'C5' AS criteria_code, 10.0000 AS weight
    UNION ALL SELECT 'DM01' AS dm_code, 'C6' AS criteria_code, 15.0000 AS weight
    UNION ALL SELECT 'DM02' AS dm_code, 'C1' AS criteria_code, 25.0000 AS weight
    UNION ALL SELECT 'DM02' AS dm_code, 'C2' AS criteria_code, 20.0000 AS weight
    UNION ALL SELECT 'DM02' AS dm_code, 'C3' AS criteria_code, 25.0000 AS weight
    UNION ALL SELECT 'DM02' AS dm_code, 'C4' AS criteria_code, 10.0000 AS weight
    UNION ALL SELECT 'DM02' AS dm_code, 'C5' AS criteria_code, 10.0000 AS weight
    UNION ALL SELECT 'DM02' AS dm_code, 'C6' AS criteria_code, 10.0000 AS weight
    UNION ALL SELECT 'DM03' AS dm_code, 'C1' AS criteria_code, 20.0000 AS weight
    UNION ALL SELECT 'DM03' AS dm_code, 'C2' AS criteria_code, 15.0000 AS weight
    UNION ALL SELECT 'DM03' AS dm_code, 'C3' AS criteria_code, 15.0000 AS weight
    UNION ALL SELECT 'DM03' AS dm_code, 'C4' AS criteria_code, 20.0000 AS weight
    UNION ALL SELECT 'DM03' AS dm_code, 'C5' AS criteria_code, 20.0000 AS weight
    UNION ALL SELECT 'DM03' AS dm_code, 'C6' AS criteria_code, 10.0000 AS weight
) AS v
JOIN decision_makers AS dm ON dm.code = v.dm_code AND dm.scenario_id = 'demo-v1'
JOIN criteria AS c ON c.code = v.criteria_code AND c.scenario_id = 'demo-v1';

-- Matriks keputusan awal X: alternatif × kriteria untuk tiap DM.
INSERT INTO alternative_evaluations (dm_id, alternative_id, criteria_id, score)
SELECT dm.id, a.id, c.id, v.score
FROM (
    SELECT 'DM01' AS dm_code, 'A1' AS alternative_code, 'C1' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A1' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A1' AS alternative_code, 'C3' AS criteria_code, 3.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A1' AS alternative_code, 'C4' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A1' AS alternative_code, 'C5' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A1' AS alternative_code, 'C6' AS criteria_code, 12.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A2' AS alternative_code, 'C1' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A2' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A2' AS alternative_code, 'C3' AS criteria_code, 3.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A2' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A2' AS alternative_code, 'C5' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A2' AS alternative_code, 'C6' AS criteria_code, 10.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A3' AS alternative_code, 'C1' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A3' AS alternative_code, 'C2' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A3' AS alternative_code, 'C3' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A3' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A3' AS alternative_code, 'C5' AS criteria_code, 3.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A3' AS alternative_code, 'C6' AS criteria_code, 14.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A4' AS alternative_code, 'C1' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A4' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A4' AS alternative_code, 'C3' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A4' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A4' AS alternative_code, 'C5' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM01' AS dm_code, 'A4' AS alternative_code, 'C6' AS criteria_code, 11.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A1' AS alternative_code, 'C1' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A1' AS alternative_code, 'C2' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A1' AS alternative_code, 'C3' AS criteria_code, 3.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A1' AS alternative_code, 'C4' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A1' AS alternative_code, 'C5' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A1' AS alternative_code, 'C6' AS criteria_code, 13.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A2' AS alternative_code, 'C1' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A2' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A2' AS alternative_code, 'C3' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A2' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A2' AS alternative_code, 'C5' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A2' AS alternative_code, 'C6' AS criteria_code, 10.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A3' AS alternative_code, 'C1' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A3' AS alternative_code, 'C2' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A3' AS alternative_code, 'C3' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A3' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A3' AS alternative_code, 'C5' AS criteria_code, 3.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A3' AS alternative_code, 'C6' AS criteria_code, 15.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A4' AS alternative_code, 'C1' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A4' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A4' AS alternative_code, 'C3' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A4' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A4' AS alternative_code, 'C5' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM02' AS dm_code, 'A4' AS alternative_code, 'C6' AS criteria_code, 9.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A1' AS alternative_code, 'C1' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A1' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A1' AS alternative_code, 'C3' AS criteria_code, 3.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A1' AS alternative_code, 'C4' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A1' AS alternative_code, 'C5' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A1' AS alternative_code, 'C6' AS criteria_code, 11.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A2' AS alternative_code, 'C1' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A2' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A2' AS alternative_code, 'C3' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A2' AS alternative_code, 'C4' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A2' AS alternative_code, 'C5' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A2' AS alternative_code, 'C6' AS criteria_code, 9.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A3' AS alternative_code, 'C1' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A3' AS alternative_code, 'C2' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A3' AS alternative_code, 'C3' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A3' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A3' AS alternative_code, 'C5' AS criteria_code, 3.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A3' AS alternative_code, 'C6' AS criteria_code, 13.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A4' AS alternative_code, 'C1' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A4' AS alternative_code, 'C2' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A4' AS alternative_code, 'C3' AS criteria_code, 5.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A4' AS alternative_code, 'C4' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A4' AS alternative_code, 'C5' AS criteria_code, 4.0000 AS score
    UNION ALL SELECT 'DM03' AS dm_code, 'A4' AS alternative_code, 'C6' AS criteria_code, 10.0000 AS score
) AS v
JOIN decision_makers AS dm ON dm.code = v.dm_code AND dm.scenario_id = 'demo-v1'
JOIN alternatives AS a ON a.code = v.alternative_code AND a.scenario_id = 'demo-v1'
JOIN criteria AS c ON c.code = v.criteria_code AND c.scenario_id = 'demo-v1';

COMMIT;
