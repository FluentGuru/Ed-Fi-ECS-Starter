CREATE TABLE adminapp.SecretConfigurations (
    Id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    EncryptedData VARCHAR NOT NULL,
    CONSTRAINT PK_SecretConfigurations PRIMARY KEY (Id)
)
