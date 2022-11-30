CREATE TABLE adminapp.UserOdsInstanceRegistrations (
    UserId VARCHAR(225) NOT NULL,
    OdsInstanceRegistrationId INT NOT NULL,
    CONSTRAINT PK_UserOdsInstanceRegistrations PRIMARY KEY (UserId, OdsInstanceRegistrationId),
    CONSTRAINT FK_UserOdsInstanceRegistrations_OdsInstanceRegistrations_Id FOREIGN KEY (OdsInstanceRegistrationId) REFERENCES adminapp.OdsInstanceRegistrations (Id) ON DELETE CASCADE,
    CONSTRAINT FK_UserOdsInstanceRegistrations_Users_Id FOREIGN KEY (UserId) REFERENCES adminapp.Users (Id) ON DELETE CASCADE
);
