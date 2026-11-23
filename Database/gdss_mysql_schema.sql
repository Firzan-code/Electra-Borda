-- GDSS ELECTRE–Borda: skema fisik MySQL/MariaDB (3NF)
-- Sumber rancangan: docs/08_ERD_DAN_STRUKTUR_DATABASE.md
-- Database ini hanya menyimpan data dummy/simulasi kecuali data_kind diubah secara sadar.

CREATE DATABASE IF NOT EXISTS gdss_electre_borda
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE gdss_electre_borda;
SET NAMES utf8mb4;

-- Master skenario
CREATE TABLE IF NOT EXISTS scenarios (
    id          VARCHAR(40)  NOT NULL,
    name        VARCHAR(120) NOT NULL,
    data_kind   VARCHAR(20)  NOT NULL DEFAULT 'dummy',
    description TEXT         NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_scenarios PRIMARY KEY (id),
    CONSTRAINT chk_scenarios_data_kind CHECK (data_kind IN ('dummy', 'real'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Alternatif platform AI yang dinilai dalam suatu skenario
CREATE TABLE IF NOT EXISTS alternatives (
    id          INT          NOT NULL AUTO_INCREMENT,
    scenario_id VARCHAR(40)  NOT NULL,
    code        VARCHAR(20)  NOT NULL,
    name        VARCHAR(120) NOT NULL,
    description VARCHAR(255) NULL,
    CONSTRAINT pk_alternatives PRIMARY KEY (id),
    CONSTRAINT uq_alternatives_scenario_code UNIQUE (scenario_id, code),
    CONSTRAINT fk_alternatives_scenario
        FOREIGN KEY (scenario_id) REFERENCES scenarios (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Kriteria dengan arah optimasi dan rentang skala eksplisit
CREATE TABLE IF NOT EXISTS criteria (
    id          INT                         NOT NULL AUTO_INCREMENT,
    scenario_id VARCHAR(40)                 NOT NULL,
    code        VARCHAR(20)                 NOT NULL,
    name        VARCHAR(120)                NOT NULL,
    type        ENUM('benefit', 'cost')     NOT NULL,
    min_val     DECIMAL(10,2)               NOT NULL DEFAULT 1.00,
    max_val     DECIMAL(10,2)               NOT NULL DEFAULT 5.00,
    unit        VARCHAR(40)                 NOT NULL,
    CONSTRAINT pk_criteria PRIMARY KEY (id),
    CONSTRAINT uq_criteria_scenario_code UNIQUE (scenario_id, code),
    CONSTRAINT chk_criteria_range CHECK (min_val <= max_val),
    CONSTRAINT fk_criteria_scenario
        FOREIGN KEY (scenario_id) REFERENCES scenarios (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Decision maker simulasi; bukan akun pengguna aplikasi
CREATE TABLE IF NOT EXISTS decision_makers (
    id          INT          NOT NULL AUTO_INCREMENT,
    scenario_id VARCHAR(40)  NOT NULL,
    code        VARCHAR(20)  NOT NULL,
    name        VARCHAR(120) NOT NULL,
    CONSTRAINT pk_decision_makers PRIMARY KEY (id),
    CONSTRAINT uq_decision_makers_scenario_code UNIQUE (scenario_id, code),
    CONSTRAINT fk_decision_makers_scenario
        FOREIGN KEY (scenario_id) REFERENCES scenarios (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bobot mentah kriteria dari setiap decision maker
CREATE TABLE IF NOT EXISTS criteria_weights (
    id          INT           NOT NULL AUTO_INCREMENT,
    dm_id       INT           NOT NULL,
    criteria_id INT           NOT NULL,
    weight      DECIMAL(10,4) NOT NULL,
    CONSTRAINT pk_criteria_weights PRIMARY KEY (id),
    CONSTRAINT uq_criteria_weights_dm_criteria UNIQUE (dm_id, criteria_id),
    CONSTRAINT chk_criteria_weights_positive CHECK (weight > 0),
    CONSTRAINT fk_criteria_weights_dm
        FOREIGN KEY (dm_id) REFERENCES decision_makers (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_criteria_weights_criteria
        FOREIGN KEY (criteria_id) REFERENCES criteria (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Matriks keputusan awal X: nilai alternatif per kriteria dari tiap DM
CREATE TABLE IF NOT EXISTS alternative_evaluations (
    id             INT           NOT NULL AUTO_INCREMENT,
    dm_id          INT           NOT NULL,
    alternative_id INT           NOT NULL,
    criteria_id    INT           NOT NULL,
    score          DECIMAL(10,4) NOT NULL,
    CONSTRAINT pk_alternative_evaluations PRIMARY KEY (id),
    CONSTRAINT uq_alternative_evaluations_dm_alternative_criteria
        UNIQUE (dm_id, alternative_id, criteria_id),
    CONSTRAINT fk_alternative_evaluations_dm
        FOREIGN KEY (dm_id) REFERENCES decision_makers (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_alternative_evaluations_alternative
        FOREIGN KEY (alternative_id) REFERENCES alternatives (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_alternative_evaluations_criteria
        FOREIGN KEY (criteria_id) REFERENCES criteria (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Snapshot/audit trail dari setiap eksekusi ELECTRE–Borda
CREATE TABLE IF NOT EXISTS calculation_runs (
    id             INT          NOT NULL AUTO_INCREMENT,
    scenario_id    VARCHAR(40)  NOT NULL,
    created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    input_hash     VARCHAR(64)  NOT NULL,
    status         VARCHAR(30)  NOT NULL,
    method_version VARCHAR(40)  NOT NULL,
    scenario_json  MEDIUMTEXT   NOT NULL,
    result_json    MEDIUMTEXT   NOT NULL,
    CONSTRAINT pk_calculation_runs PRIMARY KEY (id),
    CONSTRAINT chk_calculation_runs_input_hash_length CHECK (CHAR_LENGTH(input_hash) = 64),
    CONSTRAINT chk_calculation_runs_status
        CHECK (status IN ('unique', 'tie', 'no_discrimination')),
    CONSTRAINT fk_calculation_runs_scenario
        FOREIGN KEY (scenario_id) REFERENCES scenarios (id)
        ON DELETE CASCADE,
    INDEX ix_calculation_runs_scenario_created_at (scenario_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ringkasan hasil konsensus Borda per alternatif dan run
CREATE TABLE IF NOT EXISTS borda_results (
    id             INT           NOT NULL AUTO_INCREMENT,
    run_id         INT           NOT NULL,
    alternative_id INT           NOT NULL,
    total_points   DECIMAL(10,4) NOT NULL,
    `rank`         INT           NOT NULL,
    is_winner      TINYINT(1)    NOT NULL,
    CONSTRAINT pk_borda_results PRIMARY KEY (id),
    CONSTRAINT uq_borda_results_run_alternative UNIQUE (run_id, alternative_id),
    CONSTRAINT chk_borda_results_rank CHECK (`rank` > 0),
    CONSTRAINT chk_borda_results_is_winner CHECK (is_winner IN (0, 1)),
    CONSTRAINT fk_borda_results_run
        FOREIGN KEY (run_id) REFERENCES calculation_runs (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_borda_results_alternative
        FOREIGN KEY (alternative_id) REFERENCES alternatives (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ringkasan hasil ELECTRE I individu sebelum agregasi Borda
CREATE TABLE IF NOT EXISTS electre_dm_results (
    id           INT           NOT NULL AUTO_INCREMENT,
    run_id       INT           NOT NULL,
    dm_id        INT           NOT NULL,
    alternative_id INT         NOT NULL,
    outdegree    INT           NOT NULL,
    average_rank DECIMAL(10,2) NOT NULL,
    borda_points DECIMAL(10,4) NOT NULL,
    CONSTRAINT pk_electre_dm_results PRIMARY KEY (id),
    CONSTRAINT uq_electre_dm_results_run_dm_alternative
        UNIQUE (run_id, dm_id, alternative_id),
    CONSTRAINT chk_electre_dm_results_outdegree CHECK (outdegree >= 0),
    CONSTRAINT chk_electre_dm_results_average_rank CHECK (average_rank > 0),
    CONSTRAINT fk_electre_dm_results_run
        FOREIGN KEY (run_id) REFERENCES calculation_runs (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_electre_dm_results_dm
        FOREIGN KEY (dm_id) REFERENCES decision_makers (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_electre_dm_results_alternative
        FOREIGN KEY (alternative_id) REFERENCES alternatives (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Validasi lintas-tabel: sebuah bobot harus menghubungkan DM dan kriteria
-- yang berada di skenario yang sama.
DROP TRIGGER IF EXISTS trg_criteria_weights_before_insert;
DELIMITER //
CREATE TRIGGER trg_criteria_weights_before_insert
BEFORE INSERT ON criteria_weights
FOR EACH ROW
BEGIN
    DECLARE dm_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE criteria_scenario VARCHAR(40) DEFAULT NULL;

    SELECT scenario_id INTO dm_scenario
      FROM decision_makers WHERE id = NEW.dm_id LIMIT 1;
    SELECT scenario_id INTO criteria_scenario
      FROM criteria WHERE id = NEW.criteria_id LIMIT 1;

    IF dm_scenario IS NULL OR criteria_scenario IS NULL
       OR dm_scenario <> criteria_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DM dan kriteria pada criteria_weights harus berasal dari skenario yang sama';
    END IF;
    IF NEW.weight <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bobot kriteria harus bernilai positif';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_criteria_weights_before_update;
DELIMITER //
CREATE TRIGGER trg_criteria_weights_before_update
BEFORE UPDATE ON criteria_weights
FOR EACH ROW
BEGIN
    DECLARE dm_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE criteria_scenario VARCHAR(40) DEFAULT NULL;

    SELECT scenario_id INTO dm_scenario
      FROM decision_makers WHERE id = NEW.dm_id LIMIT 1;
    SELECT scenario_id INTO criteria_scenario
      FROM criteria WHERE id = NEW.criteria_id LIMIT 1;

    IF dm_scenario IS NULL OR criteria_scenario IS NULL
       OR dm_scenario <> criteria_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DM dan kriteria pada criteria_weights harus berasal dari skenario yang sama';
    END IF;
    IF NEW.weight <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bobot kriteria harus bernilai positif';
    END IF;
END//
DELIMITER ;

-- Validasi nilai matriks X: semua entitas harus satu skenario dan nilai harus
-- berada dalam rentang min_val..max_val dari kriterianya.
DROP TRIGGER IF EXISTS trg_alternative_evaluations_before_insert;
DELIMITER //
CREATE TRIGGER trg_alternative_evaluations_before_insert
BEFORE INSERT ON alternative_evaluations
FOR EACH ROW
BEGIN
    DECLARE dm_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE alternative_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE criteria_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE score_min DECIMAL(10,2) DEFAULT NULL;
    DECLARE score_max DECIMAL(10,2) DEFAULT NULL;

    SELECT scenario_id INTO dm_scenario
      FROM decision_makers WHERE id = NEW.dm_id LIMIT 1;
    SELECT scenario_id INTO alternative_scenario
      FROM alternatives WHERE id = NEW.alternative_id LIMIT 1;
    SELECT scenario_id, min_val, max_val
      INTO criteria_scenario, score_min, score_max
      FROM criteria WHERE id = NEW.criteria_id LIMIT 1;

    IF dm_scenario IS NULL OR alternative_scenario IS NULL OR criteria_scenario IS NULL
       OR dm_scenario <> alternative_scenario OR dm_scenario <> criteria_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DM, alternatif, dan kriteria harus berasal dari skenario yang sama';
    END IF;
    IF NEW.score < score_min OR NEW.score > score_max THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nilai evaluasi berada di luar rentang skala kriteria';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_alternative_evaluations_before_update;
DELIMITER //
CREATE TRIGGER trg_alternative_evaluations_before_update
BEFORE UPDATE ON alternative_evaluations
FOR EACH ROW
BEGIN
    DECLARE dm_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE alternative_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE criteria_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE score_min DECIMAL(10,2) DEFAULT NULL;
    DECLARE score_max DECIMAL(10,2) DEFAULT NULL;

    SELECT scenario_id INTO dm_scenario
      FROM decision_makers WHERE id = NEW.dm_id LIMIT 1;
    SELECT scenario_id INTO alternative_scenario
      FROM alternatives WHERE id = NEW.alternative_id LIMIT 1;
    SELECT scenario_id, min_val, max_val
      INTO criteria_scenario, score_min, score_max
      FROM criteria WHERE id = NEW.criteria_id LIMIT 1;

    IF dm_scenario IS NULL OR alternative_scenario IS NULL OR criteria_scenario IS NULL
       OR dm_scenario <> alternative_scenario OR dm_scenario <> criteria_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DM, alternatif, dan kriteria harus berasal dari skenario yang sama';
    END IF;
    IF NEW.score < score_min OR NEW.score > score_max THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nilai evaluasi berada di luar rentang skala kriteria';
    END IF;
END//
DELIMITER ;

-- Hasil Borda harus selalu menunjuk run dan alternatif pada skenario yang sama.
DROP TRIGGER IF EXISTS trg_borda_results_before_insert;
DELIMITER //
CREATE TRIGGER trg_borda_results_before_insert
BEFORE INSERT ON borda_results
FOR EACH ROW
BEGIN
    DECLARE run_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE alternative_scenario VARCHAR(40) DEFAULT NULL;

    SELECT scenario_id INTO run_scenario
      FROM calculation_runs WHERE id = NEW.run_id LIMIT 1;
    SELECT scenario_id INTO alternative_scenario
      FROM alternatives WHERE id = NEW.alternative_id LIMIT 1;

    IF run_scenario IS NULL OR alternative_scenario IS NULL
       OR run_scenario <> alternative_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Run dan alternatif pada borda_results harus berasal dari skenario yang sama';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_borda_results_before_update;
DELIMITER //
CREATE TRIGGER trg_borda_results_before_update
BEFORE UPDATE ON borda_results
FOR EACH ROW
BEGIN
    DECLARE run_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE alternative_scenario VARCHAR(40) DEFAULT NULL;

    SELECT scenario_id INTO run_scenario
      FROM calculation_runs WHERE id = NEW.run_id LIMIT 1;
    SELECT scenario_id INTO alternative_scenario
      FROM alternatives WHERE id = NEW.alternative_id LIMIT 1;

    IF run_scenario IS NULL OR alternative_scenario IS NULL
       OR run_scenario <> alternative_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Run dan alternatif pada borda_results harus berasal dari skenario yang sama';
    END IF;
END//
DELIMITER ;

-- Hasil ELECTRE individu harus menghubungkan run, DM, dan alternatif
-- pada skenario yang sama.
DROP TRIGGER IF EXISTS trg_electre_dm_results_before_insert;
DELIMITER //
CREATE TRIGGER trg_electre_dm_results_before_insert
BEFORE INSERT ON electre_dm_results
FOR EACH ROW
BEGIN
    DECLARE run_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE dm_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE alternative_scenario VARCHAR(40) DEFAULT NULL;

    SELECT scenario_id INTO run_scenario
      FROM calculation_runs WHERE id = NEW.run_id LIMIT 1;
    SELECT scenario_id INTO dm_scenario
      FROM decision_makers WHERE id = NEW.dm_id LIMIT 1;
    SELECT scenario_id INTO alternative_scenario
      FROM alternatives WHERE id = NEW.alternative_id LIMIT 1;

    IF run_scenario IS NULL OR dm_scenario IS NULL OR alternative_scenario IS NULL
       OR run_scenario <> dm_scenario OR run_scenario <> alternative_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Run, DM, dan alternatif pada electre_dm_results harus berasal dari skenario yang sama';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_electre_dm_results_before_update;
DELIMITER //
CREATE TRIGGER trg_electre_dm_results_before_update
BEFORE UPDATE ON electre_dm_results
FOR EACH ROW
BEGIN
    DECLARE run_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE dm_scenario VARCHAR(40) DEFAULT NULL;
    DECLARE alternative_scenario VARCHAR(40) DEFAULT NULL;

    SELECT scenario_id INTO run_scenario
      FROM calculation_runs WHERE id = NEW.run_id LIMIT 1;
    SELECT scenario_id INTO dm_scenario
      FROM decision_makers WHERE id = NEW.dm_id LIMIT 1;
    SELECT scenario_id INTO alternative_scenario
      FROM alternatives WHERE id = NEW.alternative_id LIMIT 1;

    IF run_scenario IS NULL OR dm_scenario IS NULL OR alternative_scenario IS NULL
       OR run_scenario <> dm_scenario OR run_scenario <> alternative_scenario THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Run, DM, dan alternatif pada electre_dm_results harus berasal dari skenario yang sama';
    END IF;
END//
DELIMITER ;

-- Keanggotaan skenario tidak boleh dipindah sesudah dibuat: transaksi
-- sebelumnya akan menjadi tidak konsisten jika scenario_id master berubah.
DROP TRIGGER IF EXISTS trg_alternatives_before_update;
DELIMITER //
CREATE TRIGGER trg_alternatives_before_update
BEFORE UPDATE ON alternatives
FOR EACH ROW
BEGIN
    IF NEW.scenario_id <> OLD.scenario_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'scenario_id alternatif tidak dapat diubah';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_decision_makers_before_update;
DELIMITER //
CREATE TRIGGER trg_decision_makers_before_update
BEFORE UPDATE ON decision_makers
FOR EACH ROW
BEGIN
    IF NEW.scenario_id <> OLD.scenario_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'scenario_id decision maker tidak dapat diubah';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_criteria_before_update;
DELIMITER //
CREATE TRIGGER trg_criteria_before_update
BEFORE UPDATE ON criteria
FOR EACH ROW
BEGIN
    DECLARE outside_range_count INT DEFAULT 0;

    IF NEW.scenario_id <> OLD.scenario_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'scenario_id kriteria tidak dapat diubah';
    END IF;

    SELECT COUNT(*) INTO outside_range_count
      FROM alternative_evaluations
     WHERE criteria_id = OLD.id
       AND (score < NEW.min_val OR score > NEW.max_val);

    IF outside_range_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Rentang kriteria baru tidak boleh mengecualikan nilai evaluasi yang sudah tersimpan';
    END IF;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_calculation_runs_before_update;
DELIMITER //
CREATE TRIGGER trg_calculation_runs_before_update
BEFORE UPDATE ON calculation_runs
FOR EACH ROW
BEGIN
    IF NEW.scenario_id <> OLD.scenario_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'scenario_id calculation run tidak dapat diubah';
    END IF;
    IF NEW.input_hash NOT REGEXP '^[0-9A-Fa-f]{64}$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'input_hash harus berupa SHA-256 heksadesimal 64 karakter';
    END IF;
    IF JSON_VALID(NEW.scenario_json) = 0 OR JSON_VALID(NEW.result_json) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'scenario_json dan result_json harus berupa JSON valid';
    END IF;
END//
DELIMITER ;

-- Snapshot komputasi harus memiliki hash SHA-256 heksadesimal dan payload JSON valid.
-- MEDIUMTEXT dipertahankan agar tipe kolom sama dengan kamus data pada dokumen ERD.
DROP TRIGGER IF EXISTS trg_calculation_runs_before_insert;
DELIMITER //
CREATE TRIGGER trg_calculation_runs_before_insert
BEFORE INSERT ON calculation_runs
FOR EACH ROW
BEGIN
    IF NEW.input_hash NOT REGEXP '^[0-9A-Fa-f]{64}$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'input_hash harus berupa SHA-256 heksadesimal 64 karakter';
    END IF;
    IF JSON_VALID(NEW.scenario_json) = 0 OR JSON_VALID(NEW.result_json) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'scenario_json dan result_json harus berupa JSON valid';
    END IF;
END//
DELIMITER ;

