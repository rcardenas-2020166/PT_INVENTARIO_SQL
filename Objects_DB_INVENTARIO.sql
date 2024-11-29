CREATE DATABASE DB_INVENTARIO;
USE DB_INVENTARIO;

CREATE TABLE CAT_DEPARTAMENTO (
    ID_DEPARTAMENTO INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_DEPARTAMENTO NVARCHAR(100) NOT NULL,
    FECHA_CREACION DATETIME DEFAULT GETDATE(),
	ESTADO NVARCHAR(5) DEFAULT 'A'
);

CREATE TABLE CAT_TIPO_EQUIPO (
    ID_TIPO_EQUIPO INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE_TIPO_EQUIPO NVARCHAR(100) NOT NULL,
    FECHA_CREACION DATETIME DEFAULT GETDATE(),
	ESTADO NVARCHAR(5) DEFAULT 'A'
);

CREATE TABLE CFG_CONTROL_INVENTARIO (
    ID_CONTROL_INVENTARIO INT IDENTITY(1,1) PRIMARY KEY, 
    CODIGO_INVENTARIO NVARCHAR(50) UNIQUE NOT NULL,      
    MARCA NVARCHAR(100) NOT NULL,                       
    ID_TIPO_EQUIPO INT NOT NULL,                        
    ID_DEPARTAMENTO INT NOT NULL,                      
    FECHA_ASIGNACION DATETIME DEFAULT GETDATE(),                          
    NOMBRE_RESPONSABLE NVARCHAR(100) NOT NULL,                   
    FECHA_INGRESO_INVENTARIO DATETIME DEFAULT GETDATE(),
    ESTADO NVARCHAR(5) DEFAULT 'A',                     

    CONSTRAINT FK_TIPO_EQUIPO FOREIGN KEY (ID_TIPO_EQUIPO)
        REFERENCES CAT_TIPO_EQUIPO(ID_TIPO_EQUIPO),
    CONSTRAINT FK_DEPARTAMENTO FOREIGN KEY (ID_DEPARTAMENTO)
        REFERENCES CAT_DEPARTAMENTO(ID_DEPARTAMENTO)
);

-- SPS DEPARTAMENTO --
CREATE  OR ALTER  PROCEDURE sp_insert_departamento    
      
@jsonInput NVARCHAR(MAX)      
AS      
BEGIN          
    BEGIN TRANSACTION;            
    DECLARE @response NVARCHAR(MAX);            
    
    BEGIN TRY      
        INSERT INTO CAT_DEPARTAMENTO(NOMBRE_DEPARTAMENTO, ESTADO)      
        SELECT     
            [nombre_departamento]  
        FROM OPENJSON(@jsonInput)      
        WITH (    
            nombre_departamento NVARCHAR(MAX) '$.NOMBRE_DEPARTAMENTO'
        );      
    
        COMMIT TRANSACTION;      
    
        SELECT (      
            SELECT      
                'SUCCESS' AS status,      
                'Departamento registrado correctamente.' AS message      
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER      
        ) AS JsonResponse;      
    END TRY      
    
    BEGIN CATCH      
        ROLLBACK TRANSACTION;      
    
        SELECT (      
            SELECT      
                'ERROR' AS status,      
                ERROR_MESSAGE() AS message      
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER      
        ) AS JsonResponse;      
    END CATCH      
END; 

CREATE OR ALTER  PROCEDURE sp_update_departamento    
    @jsonInput NVARCHAR(MAX)    
AS    
BEGIN    
    BEGIN TRANSACTION;    
    
    DECLARE @response NVARCHAR(MAX);    
    
    BEGIN TRY    
        UPDATE CAT_DEPARTAMENTO    
        SET    
            NOMBRE_DEPARTAMENTO = JSON_VALUE(@jsonInput, '$.NOMBRE_DEPARTAMENTO')
        WHERE    
            ID_DEPARTAMENTO = JSON_VALUE(@jsonInput, '$.ID_DEPARTAMENTO');    
        COMMIT TRANSACTION;    
    
        SELECT (    
            SELECT    
                'SUCCESS' AS status,    
                'Departamento actualizado correctamente.' AS message    
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER    
        ) AS JsonResponse;    
    END TRY    
    BEGIN CATCH    
        ROLLBACK TRANSACTION;    
    
        SELECT (    
            SELECT    
                'ERROR' AS status,    
                ERROR_MESSAGE() AS message    
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER    
        ) AS JsonResponse;    
    END CATCH    
END; 

CREATE OR ALTER PROCEDURE sp_delete_departamento
    @jsonInput NVARCHAR(MAX)  
AS  
BEGIN  
    BEGIN TRANSACTION;  
  
    DECLARE @response NVARCHAR(MAX);  
  
    BEGIN TRY  
        UPDATE CAT_DEPARTAMENTO  
        SET  
            NOMBRE_DEPARTAMENTO = JSON_VALUE(@jsonInput, '$.NOMBRE_DEPARTAMENTO'),  
            ESTADO = 'I'  
        WHERE  
            ID_DEPARTAMENTO = JSON_VALUE(@jsonInput, '$.ID_DEPARTAMENTO');  
  
        COMMIT TRANSACTION;  
  
        SELECT (  
            SELECT  
                'SUCCESS' AS status,  
                'Departamento eliminado correctamente.' AS message  
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  
        ) AS JsonResponse;  
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;  
  
        SELECT (  
            SELECT  
                'ERROR' AS status,  
                ERROR_MESSAGE() AS message  
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  
        ) AS JsonResponse;  
    END CATCH  
END;  


-- SPS TIPO EQUIPO --
CREATE  OR ALTER  PROCEDURE sp_insert_tipo_equipo   
      
@jsonInput NVARCHAR(MAX)      
AS      
BEGIN          
    BEGIN TRANSACTION;            
    DECLARE @response NVARCHAR(MAX);            
    
    BEGIN TRY      
        INSERT INTO CAT_TIPO_EQUIPO(NOMBRE_TIPO_EQUIPO)      
        SELECT     
            [nombre_tipo_equipo]  
        FROM OPENJSON(@jsonInput)      
        WITH (    
            nombre_Tipo_equipo NVARCHAR(MAX) '$.NOMBRE_TIPO_EQUIPO'
        );      
    
        COMMIT TRANSACTION;      
    
        SELECT (      
            SELECT      
                'SUCCESS' AS status,      
                'Tipo de Equipo registrado correctamente.' AS message      
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER      
        ) AS JsonResponse;      
    END TRY      
    
    BEGIN CATCH      
        ROLLBACK TRANSACTION;      
    
        SELECT (      
            SELECT      
                'ERROR' AS status,      
                ERROR_MESSAGE() AS message      
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER      
        ) AS JsonResponse;      
    END CATCH      
END; 

CREATE OR ALTER  PROCEDURE sp_update_tipo_equipo   
    @jsonInput NVARCHAR(MAX)    
AS    
BEGIN    
    BEGIN TRANSACTION;    
    
    DECLARE @response NVARCHAR(MAX);    
    
    BEGIN TRY    
        UPDATE CAT_TIPO_EQUIPO    
        SET    
            NOMBRE_TIPO_EQUIPO = JSON_VALUE(@jsonInput, '$.NOMBRE_TIPO_EQUIPO')
        WHERE    
            ID_TIPO_EQUIPO = JSON_VALUE(@jsonInput, '$.ID_TIPO_EQUIPO');    
        COMMIT TRANSACTION;    
    
        SELECT (    
            SELECT    
                'SUCCESS' AS status,    
                'Tipo de Equipo actualizado correctamente.' AS message    
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER    
        ) AS JsonResponse;    
    END TRY    
    BEGIN CATCH    
        ROLLBACK TRANSACTION;    
    
        SELECT (    
            SELECT    
                'ERROR' AS status,    
                ERROR_MESSAGE() AS message    
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER    
        ) AS JsonResponse;    
    END CATCH    
END; 

CREATE OR ALTER PROCEDURE sp_delete_tipo_equipo
    @jsonInput NVARCHAR(MAX)  
AS  
BEGIN  
    BEGIN TRANSACTION;  
  
    DECLARE @response NVARCHAR(MAX);  
  
    BEGIN TRY  
        UPDATE CAT_TIPO_EQUIPO  
        SET  
            NOMBRE_TIPO_EQUIPO = JSON_VALUE(@jsonInput, '$.NOMBRE_TIPO_EQUIPO'),  
            ESTADO = 'I'  
        WHERE  
            ID_TIPO_EQUIPO = JSON_VALUE(@jsonInput, '$.ID_TIPO_EQUIPO');  
  
        COMMIT TRANSACTION;  
  
        SELECT (  
            SELECT  
                'SUCCESS' AS status,  
                'Tipo de Equipo eliminado correctamente.' AS message  
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  
        ) AS JsonResponse;  
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;  
  
        SELECT (  
            SELECT  
                'ERROR' AS status,  
                ERROR_MESSAGE() AS message  
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  
        ) AS JsonResponse;  
    END CATCH  
END;  


-- SPS INVENTARIO --

CREATE OR ALTER PROCEDURE sp_insert_control_inventario
@JsonInput NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRANSACTION;
    DECLARE @response NVARCHAR(MAX);

    BEGIN TRY
        INSERT INTO CFG_CONTROL_INVENTARIO (
            CODIGO_INVENTARIO,
            MARCA,
            ID_TIPO_EQUIPO,
            ID_DEPARTAMENTO,
            NOMBRE_RESPONSABLE
        )
        SELECT 
            [codigo_inventario],
            [marca],
            [id_tipo_equipo],
            [id_departamento],
            [nombre_responsable]
        FROM OPENJSON(@JsonInput)
        WITH (
            codigo_inventario NVARCHAR(50) '$.CODIGO_INVENTARIO',
            marca NVARCHAR(100) '$.MARCA',
            id_tipo_equipo INT '$.ID_TIPO_EQUIPO',
            id_departamento INT '$.ID_DEPARTAMENTO',
            nombre_responsable NVARCHAR(100) '$.NOMBRE_RESPONSABLE'
        );

        COMMIT TRANSACTION;

        SELECT (
            SELECT
                'SUCCESS' AS status,
                'Registro almacenado correctamente.' AS message
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS JsonResponse;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT (
            SELECT
                'ERROR' AS status,
                ERROR_MESSAGE() AS message
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS JsonResponse;
    END CATCH
END;

CREATE OR ALTER  PROCEDURE sp_update_control_inventario  
    @jsonInput NVARCHAR(MAX)    
AS    
BEGIN    
    BEGIN TRANSACTION;    
    
    DECLARE @response NVARCHAR(MAX);    
    
    BEGIN TRY    
        UPDATE CFG_CONTROL_INVENTARIO    
        SET    
            NOMBRE_RESPONSABLE = JSON_VALUE(@jsonInput, '$.NOMBRE_RESPONSABLE'),
            MARCA = JSON_VALUE(@jsonInput, '$.MARCA'),
            ID_DEPARTAMENTO = JSON_VALUE(@jsonInput, '$.ID_DEPARTAMENTO'),
            ID_TIPO_EQUIPO = JSON_VALUE(@jsonInput, '$.ID_TIPO_EQUIPO')
        WHERE    
            ID_CONTROL_INVENTARIO = JSON_VALUE(@jsonInput, '$.ID_CONTROL_INVENTARIO');    
        COMMIT TRANSACTION;    
    
        SELECT (    
            SELECT    
                'SUCCESS' AS status,    
                'Registro actualizado correctamente.' AS message    
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER    
        ) AS JsonResponse;    
    END TRY    
    BEGIN CATCH    
        ROLLBACK TRANSACTION;    
    
        SELECT (    
            SELECT    
                'ERROR' AS status,    
                ERROR_MESSAGE() AS message    
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER    
        ) AS JsonResponse;    
    END CATCH    
END; 

CREATE OR ALTER PROCEDURE sp_delete_control_inventario
    @jsonInput NVARCHAR(MAX)  
AS  
BEGIN  
    BEGIN TRANSACTION;  
  
    DECLARE @response NVARCHAR(MAX);  
  
    BEGIN TRY  
        UPDATE CFG_CONTROL_INVENTARIO  
        SET  
            ESTADO = 'I'  
        WHERE  
            ID_CONTROL_INVENTARIO = JSON_VALUE(@jsonInput, '$.ID_CONTROL_INVENTARIO');  
  
        COMMIT TRANSACTION;  
  
        SELECT (  
            SELECT  
                'SUCCESS' AS status,  
                'Registro eliminado correctamente.' AS message  
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  
        ) AS JsonResponse;  
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;  
  
        SELECT (  
            SELECT  
                'ERROR' AS status,  
                ERROR_MESSAGE() AS message  
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  
        ) AS JsonResponse;  
    END CATCH  
END;  