-- +micrate Up
CREATE TABLE tests (
  id BIGSERIAL PRIMARY KEY,
  num BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS tests;
