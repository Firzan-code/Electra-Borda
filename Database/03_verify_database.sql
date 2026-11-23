-- Verifikasi integritas database GDSS ELECTRE–Borda.
-- Jalankan setelah gdss_mysql_schema.sql dan gdss_mysql_seed.sql.
-- Semua data uji dibatalkan dengan ROLLBACK.

USE gdss_electre_borda;
SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS verify_gdss_database;
DELIMITER //
CREATE PROCEDURE verify_gdss_database()
BEGIN
    DECLARE actual_count INT DEFAULT 0;
    DECLARE rejected TINYINT DEFAULT 0;
    DECLARE test_dm_id INT DEFAULT NULL;
    DECLARE test_alt_id INT DEFAULT NULL;
    DECLARE test_criteria_id INT DEFAULT NULL;
    DECLARE other_alt_id INT DEFAULT NULL;
    DECLARE test_run_id INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Semua tabel dan relasi cascade dari ERD harus tersedia.
    SELECT COUNT(*) INTO actual_count FROM information_schema.tables
     WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE';
    IF actual_count <> 9 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: jumlah tabel bukan 9';
    END IF;
    SELECT COUNT(*) INTO actual_count FROM information_schema.referential_constraints
     WHERE constraint_schema = DATABASE() AND delete_rule = 'CASCADE';
    IF actual_count <> 14 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: relasi ON DELETE CASCADE bukan 14';
    END IF;

    -- Seed wajib sesuai data/demo.json.
    SELECT COUNT(*) INTO actual_count FROM scenarios WHERE id = 'demo-v1';
    IF actual_count <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: scenarios demo-v1 harus berjumlah 1';
    END IF;

    SELECT COUNT(*) INTO actual_count FROM alternatives WHERE scenario_id = 'demo-v1';
    IF actual_count <> 4 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: alternatives demo-v1 harus berjumlah 4';
    END IF;

    SELECT COUNT(*) INTO actual_count FROM criteria WHERE scenario_id = 'demo-v1';
    IF actual_count <> 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: criteria demo-v1 harus berjumlah 6';
    END IF;

    SELECT COUNT(*) INTO actual_count FROM decision_makers WHERE scenario_id = 'demo-v1';
    IF actual_count <> 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: decision_makers demo-v1 harus berjumlah 3';
    END IF;

    SELECT COUNT(*) INTO actual_count
      FROM criteria_weights AS cw
      JOIN decision_makers AS dm ON dm.id = cw.dm_id
     WHERE dm.scenario_id = 'demo-v1';
    IF actual_count <> 18 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: criteria_weights demo-v1 harus berjumlah 18';
    END IF;

    SELECT COUNT(*) INTO actual_count
      FROM alternative_evaluations AS ae
      JOIN decision_makers AS dm ON dm.id = ae.dm_id
     WHERE dm.scenario_id = 'demo-v1';
    IF actual_count <> 72 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: alternative_evaluations demo-v1 harus berjumlah 72';
    END IF;

    -- Nilai seed harus sama persis dengan data/demo.json, bukan hanya jumlah baris.
    SELECT COUNT(*) INTO actual_count FROM scenarios
     WHERE id = 'demo-v1'
       AND HEX(name) = '50656D696C6968616E20706C6174666F726D20414920E280942073696D756C61736920616B6164656D696B'
       AND data_kind = 'dummy';
    IF actual_count <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: metadata scenario demo-v1 tidak sesuai demo.json';
    END IF;

    SELECT COUNT(*) INTO actual_count
      FROM (
        SELECT 'A1' AS code, 'ChatGPT' AS name
        UNION ALL SELECT 'A2' AS code, 'Gemini' AS name
        UNION ALL SELECT 'A3' AS code, 'Claude' AS name
        UNION ALL SELECT 'A4' AS code, 'Perplexity' AS name
      ) AS expected
      LEFT JOIN alternatives AS actual
        ON actual.scenario_id = 'demo-v1'
       AND actual.code = expected.code
       AND actual.name = expected.name
     WHERE actual.id IS NULL;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: nilai alternatives tidak sesuai demo.json';
    END IF;

    SELECT COUNT(*) INTO actual_count
      FROM (
        SELECT 'C1' AS code, 'Ketepatan isi' AS name, 'benefit' AS criterion_type, 'skor' AS unit, 1.00 AS min_val, 5.00 AS max_val
        UNION ALL SELECT 'C2' AS code, 'Relevansi respons' AS name, 'benefit' AS criterion_type, 'skor' AS unit, 1.00 AS min_val, 5.00 AS max_val
        UNION ALL SELECT 'C3' AS code, 'Keterlacakan referensi' AS name, 'benefit' AS criterion_type, 'skor' AS unit, 1.00 AS min_val, 5.00 AS max_val
        UNION ALL SELECT 'C4' AS code, 'Kemudahan penggunaan' AS name, 'benefit' AS criterion_type, 'skor' AS unit, 1.00 AS min_val, 5.00 AS max_val
        UNION ALL SELECT 'C5' AS code, 'Kecukupan akses' AS name, 'benefit' AS criterion_type, 'skor' AS unit, 1.00 AS min_val, 5.00 AS max_val
        UNION ALL SELECT 'C6' AS code, 'Waktu penyelesaian' AS name, 'cost' AS criterion_type, 'menit simulasi' AS unit, 1.00 AS min_val, 60.00 AS max_val
      ) AS expected
      LEFT JOIN criteria AS actual
        ON actual.scenario_id = 'demo-v1'
       AND actual.code = expected.code
       AND actual.name = expected.name
       AND actual.type = expected.criterion_type
       AND actual.unit = expected.unit
       AND actual.min_val = expected.min_val
       AND actual.max_val = expected.max_val
     WHERE actual.id IS NULL;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: metadata criteria tidak sesuai demo.json';
    END IF;

    SELECT COUNT(*) INTO actual_count
      FROM (
        SELECT 'DM01' AS code, 'Penilai simulasi 01' AS name
        UNION ALL SELECT 'DM02' AS code, 'Penilai simulasi 02' AS name
        UNION ALL SELECT 'DM03' AS code, 'Penilai simulasi 03' AS name
      ) AS expected
      LEFT JOIN decision_makers AS actual
        ON actual.scenario_id = 'demo-v1'
       AND actual.code = expected.code
       AND actual.name = expected.name
     WHERE actual.id IS NULL;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: nilai decision_makers tidak sesuai demo.json';
    END IF;

    SELECT COUNT(*) INTO actual_count
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
      ) AS expected
      LEFT JOIN decision_makers AS dm
        ON dm.scenario_id = 'demo-v1' AND dm.code = expected.dm_code
      LEFT JOIN criteria AS c
        ON c.scenario_id = 'demo-v1' AND c.code = expected.criteria_code
      LEFT JOIN criteria_weights AS actual
        ON actual.dm_id = dm.id AND actual.criteria_id = c.id
       AND actual.weight = expected.weight
     WHERE actual.id IS NULL;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: nilai criteria_weights tidak sesuai demo.json';
    END IF;

    SELECT COUNT(*) INTO actual_count
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
      ) AS expected
      LEFT JOIN decision_makers AS dm
        ON dm.scenario_id = 'demo-v1' AND dm.code = expected.dm_code
      LEFT JOIN alternatives AS a
        ON a.scenario_id = 'demo-v1' AND a.code = expected.alternative_code
      LEFT JOIN criteria AS c
        ON c.scenario_id = 'demo-v1' AND c.code = expected.criteria_code
      LEFT JOIN alternative_evaluations AS actual
        ON actual.dm_id = dm.id
       AND actual.alternative_id = a.id
       AND actual.criteria_id = c.id
       AND actual.score = expected.score
     WHERE actual.id IS NULL;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: nilai alternative_evaluations tidak sesuai demo.json';
    END IF;
    START TRANSACTION;

    -- Dua skenario sementara dipakai untuk menguji constraint lintas-skenario.
    INSERT INTO scenarios (id, name, data_kind, description)
    VALUES
        ('__db_verify_main__', 'Skenario verifikasi utama', 'dummy', 'Data sementara; selalu di-rollback.'),
        ('__db_verify_other__', 'Skenario verifikasi pembanding', 'dummy', 'Data sementara; selalu di-rollback.');

    INSERT INTO alternatives (scenario_id, code, name)
    VALUES ('__db_verify_main__', 'A1', 'Alternatif uji');
    SET test_alt_id = LAST_INSERT_ID();

    INSERT INTO alternatives (scenario_id, code, name)
    VALUES ('__db_verify_other__', 'A2', 'Alternatif skenario lain');
    SET other_alt_id = LAST_INSERT_ID();

    INSERT INTO criteria (scenario_id, code, name, type, min_val, max_val, unit)
    VALUES ('__db_verify_main__', 'C1', 'Kriteria uji', 'benefit', 1.00, 5.00, 'skala 1-5');
    SET test_criteria_id = LAST_INSERT_ID();

    INSERT INTO decision_makers (scenario_id, code, name)
    VALUES ('__db_verify_main__', 'DM01', 'Decision maker uji');
    SET test_dm_id = LAST_INSERT_ID();

    -- Bobot nol harus ditolak.
    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        INSERT INTO criteria_weights (dm_id, criteria_id, weight)
        VALUES (test_dm_id, test_criteria_id, 0.0000);
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: bobot nol diterima';
    END IF;

    INSERT INTO criteria_weights (dm_id, criteria_id, weight)
    VALUES (test_dm_id, test_criteria_id, 1.0000);

    -- Skor di luar rentang kriteria harus ditolak.
    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        INSERT INTO alternative_evaluations (dm_id, alternative_id, criteria_id, score)
        VALUES (test_dm_id, test_alt_id, test_criteria_id, 6.0000);
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: skor di luar skala diterima';
    END IF;

    INSERT INTO alternative_evaluations (dm_id, alternative_id, criteria_id, score)
    VALUES (test_dm_id, test_alt_id, test_criteria_id, 5.0000);

    -- Kombinasi entitas dari dua skenario harus ditolak.
    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        INSERT INTO alternative_evaluations (dm_id, alternative_id, criteria_id, score)
        VALUES (test_dm_id, other_alt_id, test_criteria_id, 4.0000);
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: evaluasi lintas-skenario diterima';
    END IF;

    -- Mempersempit rentang tidak boleh membuat penilaian tersimpan tidak valid.
    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        UPDATE criteria SET max_val = 4.00 WHERE id = test_criteria_id;
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: rentang baru mengecualikan skor tersimpan';
    END IF;

    -- Pemindahan entitas ke skenario lain akan merusak integritas transaksi.
    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        UPDATE alternatives SET scenario_id = '__db_verify_other__' WHERE id = test_alt_id;
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: alternatif dipindahkan lintas skenario';
    END IF;

    -- Hash bukan SHA-256 dan snapshot bukan JSON harus ditolak.
    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        INSERT INTO calculation_runs
            (scenario_id, input_hash, status, method_version, scenario_json, result_json)
        VALUES
            ('__db_verify_main__', 'not-a-sha256', 'unique', 'electre-borda-v1', '{}', '{}');
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: input_hash tidak valid diterima';
    END IF;

    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        INSERT INTO calculation_runs
            (scenario_id, input_hash, status, method_version, scenario_json, result_json)
        VALUES
            ('__db_verify_main__', REPEAT('a', 64), 'unique', 'electre-borda-v1', 'bukan JSON', '{}');
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: snapshot JSON tidak valid diterima';
    END IF;

    INSERT INTO calculation_runs
        (scenario_id, input_hash, status, method_version, scenario_json, result_json)
    VALUES
        ('__db_verify_main__', REPEAT('a', 64), 'unique', 'electre-borda-v1', '{}', '{}');
    SET test_run_id = LAST_INSERT_ID();

    -- Update snapshot tidak valid juga harus ditolak.
    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        UPDATE calculation_runs SET result_json = 'bukan JSON' WHERE id = test_run_id;
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: update snapshot JSON tidak valid diterima';
    END IF;

    INSERT INTO borda_results
        (run_id, alternative_id, total_points, `rank`, is_winner)
    VALUES
        (test_run_id, test_alt_id, 1.0000, 1, 1);

    INSERT INTO electre_dm_results
        (run_id, dm_id, alternative_id, outdegree, average_rank, borda_points)
    VALUES
        (test_run_id, test_dm_id, test_alt_id, 0, 1.00, 0.0000);

    SET rejected = 0;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = 1;
        INSERT INTO borda_results
            (run_id, alternative_id, total_points, `rank`, is_winner)
        VALUES
            (test_run_id, other_alt_id, 0.0000, 2, 0);
    END;
    IF rejected <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: hasil Borda lintas-skenario diterima';
    END IF;

    -- Menghapus skenario utama harus menghapus semua data turunannya.
    DELETE FROM scenarios WHERE id = '__db_verify_main__';

    SELECT COUNT(*) INTO actual_count FROM alternatives WHERE id = test_alt_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade alternatives tidak berjalan';
    END IF;

    SELECT COUNT(*) INTO actual_count FROM criteria WHERE id = test_criteria_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade criteria tidak berjalan';
    END IF;

    SELECT COUNT(*) INTO actual_count FROM decision_makers WHERE id = test_dm_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade decision_makers tidak berjalan';
    END IF;

    SELECT COUNT(*) INTO actual_count FROM calculation_runs WHERE id = test_run_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade calculation_runs tidak berjalan';
    END IF;

    SELECT COUNT(*) INTO actual_count FROM criteria_weights WHERE dm_id = test_dm_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade bobot tidak berjalan';
    END IF;
    SELECT COUNT(*) INTO actual_count FROM alternative_evaluations WHERE dm_id = test_dm_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade evaluasi tidak berjalan';
    END IF;
    SELECT COUNT(*) INTO actual_count FROM borda_results WHERE run_id = test_run_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade hasil Borda tidak berjalan';
    END IF;
    SELECT COUNT(*) INTO actual_count FROM electre_dm_results WHERE run_id = test_run_id;
    IF actual_count <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikasi gagal: cascade hasil ELECTRE tidak berjalan';
    END IF;

    ROLLBACK;

    SELECT
        'PASS' AS verification_status,
        '9 tabel, seed, validasi bobot/skor/skenario, dan cascade terverifikasi' AS details;
END//
DELIMITER ;

CALL verify_gdss_database();
DROP PROCEDURE verify_gdss_database;
