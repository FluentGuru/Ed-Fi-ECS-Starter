CREATE TABLE adminapp.DataProtectionKeys (
    Id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    FriendlyName VARCHAR NULL,
    Xml VARCHAR NULL,
    CONSTRAINT PK_DataProtectionKeys PRIMARY KEY (Id)
)
