PGDMP     4    9    
            {         	   groupnova    14.4    15.2    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    23061 	   groupnova    DATABASE     �   CREATE DATABASE groupnova WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Guatemala.1252';
    DROP DATABASE groupnova;
                vince    false            �           0    0    DATABASE groupnova    COMMENT     C   COMMENT ON DATABASE groupnova IS 'contendra las tablas generales';
                   vince    false    4488                        2615    25969    compras_cuenta    SCHEMA        CREATE SCHEMA compras_cuenta;
    DROP SCHEMA compras_cuenta;
                vince    false                        2615    25967    compras_cuenta_bancaria    SCHEMA     '   CREATE SCHEMA compras_cuenta_bancaria;
 %   DROP SCHEMA compras_cuenta_bancaria;
                vince    false                        2615    25966    compras_orden_compra    SCHEMA     $   CREATE SCHEMA compras_orden_compra;
 "   DROP SCHEMA compras_orden_compra;
                vince    false                        2615    25968    compras_presupuesto    SCHEMA     #   CREATE SCHEMA compras_presupuesto;
 !   DROP SCHEMA compras_presupuesto;
                vince    false                        2615    25964    compras_producto    SCHEMA         CREATE SCHEMA compras_producto;
    DROP SCHEMA compras_producto;
                vince    false                        2615    25963    compras_proveedor    SCHEMA     !   CREATE SCHEMA compras_proveedor;
    DROP SCHEMA compras_proveedor;
                vince    false                        2615    25970    compras_recepcion    SCHEMA     !   CREATE SCHEMA compras_recepcion;
    DROP SCHEMA compras_recepcion;
                vince    false                        2615    25965    compras_solicitud    SCHEMA     !   CREATE SCHEMA compras_solicitud;
    DROP SCHEMA compras_solicitud;
                vince    false                        2615    24590    general    SCHEMA        CREATE SCHEMA general;
    DROP SCHEMA general;
                vince    false                        2615    24202    nova_aplicacion    SCHEMA        CREATE SCHEMA nova_aplicacion;
    DROP SCHEMA nova_aplicacion;
                vince    false                        2615    24463    nova_dispositivo    SCHEMA         CREATE SCHEMA nova_dispositivo;
    DROP SCHEMA nova_dispositivo;
                vince    false            	            2615    24220 
   nova_falta    SCHEMA        CREATE SCHEMA nova_falta;
    DROP SCHEMA nova_falta;
                vince    false                        2615    24462    nova_horario    SCHEMA        CREATE SCHEMA nova_horario;
    DROP SCHEMA nova_horario;
                vince    false            
            2615    24221    nova_metrica    SCHEMA        CREATE SCHEMA nova_metrica;
    DROP SCHEMA nova_metrica;
                vince    false                        2615    24201    nova_proceso_tarea    SCHEMA     "   CREATE SCHEMA nova_proceso_tarea;
     DROP SCHEMA nova_proceso_tarea;
                vince    false                        2615    24836    nova_ticket    SCHEMA        CREATE SCHEMA nova_ticket;
    DROP SCHEMA nova_ticket;
                vince    false                        2615    26461    nova_version    SCHEMA        CREATE SCHEMA nova_version;
    DROP SCHEMA nova_version;
                vince    false                        2615    23062    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                vince    false                        3079    23304    dblink 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA usuarios;
    DROP EXTENSION dblink;
                   false    6            �           0    0    EXTENSION dblink    COMMENT     _   COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';
                        false    2            �           1255    26785 8   get_cuenta(character varying, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION compras_cuenta.get_cuenta(cuenta_nombre character varying, int_clasificacion_id integer, int_id_creado_por integer, int_id_actualizado_por integer) RETURNS TABLE(cuenta_id integer, nombre character varying, clasificacion_id integer, clasificacion_nombre character varying, descripcion character varying, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_id integer, actualizado_por_id integer, creado_por character varying, actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  select tcc.id_cat_cuenta as cuenta_id,
  tcc.nombre as nombre,
  tccc.id_cat_cuenta_clasificacion as clasificacion_id,
  tccc.nombre as clasificacion_nombre,
  tcc.descripcion as descripcion,
  tcc.estado as estado,
  to_char(tcc.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion,
  to_char(tcc.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion,
  tcc.creado_por as creado_por_id,
  tcc.actualizado_por as actualizado_por_id,
  creado_por.nombre as creado_por,
  modificado_por.nombre as actualizado_por
  from compras_cuenta.tbl_cat_cuenta tcc 
  join compras_cuenta.tbl_cat_cuenta_clasificacion tccc 
  on tcc.id_cat_cuenta_clasificacion  =  tccc.id_cat_cuenta_clasificacion 
  LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tcc.creado_por) creado_por ON true
  LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tcc.actualizado_por) modificado_por ON true
  where (upper(tcc.nombre) LIKE ('%' || upper(cuenta_nombre)  || '%')::varchar or LENGTH (upper(cuenta_nombre)) = 0)
  and (tcc.id_cat_cuenta_clasificacion  = int_clasificacion_id  or int_clasificacion_id = 0)
and (tcc.creado_por = int_id_creado_por  or int_id_creado_por = 0)
and (tcc.actualizado_por = int_id_actualizado_por  or int_id_actualizado_por = 0)

;
END;
$$;
 �   DROP FUNCTION compras_cuenta.get_cuenta(cuenta_nombre character varying, int_clasificacion_id integer, int_id_creado_por integer, int_id_actualizado_por integer);
       compras_cuenta          vince    false    21            �           1255    26782 =   get_cuenta_clasificacion(character varying, integer, integer)    FUNCTION     l  CREATE FUNCTION compras_cuenta.get_cuenta_clasificacion(cuenta_clasficacion_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer) RETURNS TABLE(clasificacion_id integer, nombre character varying, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_id integer, creado_por character varying, actualizado_por_id integer, actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  
  select 
  tccc.id_cat_cuenta_clasificacion  as clasificacion_id,
  tccc.nombre  as nombre,
  tccc.estado as estado,
  to_char(tccc.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion,
  to_char(tccc.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion,
  tccc.creado_por as creado_por_id,
  creado_por.nombre as creado_por,
  tccc.actualizado_por as actualizado_por_id,
  modificado_por.nombre as actualizado_por
  from compras_cuenta.tbl_cat_cuenta_clasificacion tccc 
  LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tccc.creado_por) creado_por ON true
  LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tccc.actualizado_por) modificado_por ON true
  where (upper(tccc.nombre) LIKE ('%' || upper(cuenta_clasficacion_nombre)  || '%')::varchar or LENGTH (upper(cuenta_clasficacion_nombre)) = 0)
and (tccc.creado_por = int_id_creado_por  or int_id_creado_por = 0)
and (tccc.actualizado_por = int_id_actualizado_por  or int_id_actualizado_por = 0)
  
;
END;
$$;
 �   DROP FUNCTION compras_cuenta.get_cuenta_clasificacion(cuenta_clasficacion_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer);
       compras_cuenta          vince    false    21            �           1255    26783 M   sp_tbl_cat_cuenta_add(integer, character varying, character varying, integer) 	   PROCEDURE     -  CREATE PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_add(IN int_clasificacion_id integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_creado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
INSERT INTO compras_cuenta.tbl_cat_cuenta (
	id_cat_cuenta_clasificacion
	,nombre
	,descripcion
	,estado
	,fecha_creacion
	,fecha_actualizacion
	,creado_por
	,actualizado_por
	)
VALUES (
	int_clasificacion_id
	,str_nombre
	,str_descripcion
	,1
	,now()
	,now()
	,int_creado_por
	,int_creado_por
	);

end
$$;
 �   DROP PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_add(IN int_clasificacion_id integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_creado_por integer);
       compras_cuenta          vince    false    21            �           1255    26780 ?   sp_tbl_cat_cuenta_clasificacion_add(character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_clasificacion_add(IN str_nombre character varying, IN int_creado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
	INSERT INTO compras_cuenta.tbl_cat_cuenta_clasificacion (
	nombre
	,estado
	,fecha_creacion
	,fecha_actualizacion
	,creado_por
	,actualizado_por
	)
VALUES (
	str_nombre
	,1
	,now()
	,NOW()
	,int_creado_por
	,int_creado_por
	);

end
$$;
    DROP PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_clasificacion_add(IN str_nombre character varying, IN int_creado_por integer);
       compras_cuenta          vince    false    21            �           1255    26781 T   sp_tbl_cat_cuenta_clasificacion_update(integer, character varying, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_clasificacion_update(IN int_clasificacion_id integer, IN str_nombre character varying, IN int_estado integer, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
	UPDATE compras_cuenta.tbl_cat_cuenta_clasificacion
SET nombre = str_nombre
	,estado = int_estado
	,fecha_actualizacion = now()
	,actualizado_por = int_actualizado_por
WHERE id_cat_cuenta_clasificacion = int_clasificacion_id;


end
$$;
 �   DROP PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_clasificacion_update(IN int_clasificacion_id integer, IN str_nombre character varying, IN int_estado integer, IN int_actualizado_por integer);
       compras_cuenta          vince    false    21            �           1255    26784 b   sp_tbl_cat_cuenta_update(integer, integer, character varying, character varying, integer, integer) 	   PROCEDURE     E  CREATE PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_update(IN int_cuenta_id integer, IN int_clasificacion_id integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
UPDATE compras_cuenta.tbl_cat_cuenta
SET id_cat_cuenta_clasificacion = int_clasificacion_id
	,nombre = str_nombre
	,descripcion = str_descripcion
	,estado = int_estado
	,fecha_actualizacion = now()
	,actualizado_por = int_actualizado_por
WHERE id_cat_cuenta = int_cuenta_id;


end
$$;
 �   DROP PROCEDURE compras_cuenta.sp_tbl_cat_cuenta_update(IN int_cuenta_id integer, IN int_clasificacion_id integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_actualizado_por integer);
       compras_cuenta          vince    false    21            �           1255    26634 G   get_bit_presupuesto_ajuste(integer, integer, integer, integer, integer)    FUNCTION     ;  CREATE FUNCTION compras_presupuesto.get_bit_presupuesto_ajuste(int_id_cuenta_abono integer, int_id_cuenta_cargo integer, int_id_det_presupuesto integer, int_id_cat_usuario_creado_por integer, int_id_cat_usuario_actualizado_por integer) RETURNS TABLE(ajuste_id integer, det_presupuesto_id integer, mes text, cuenta_cargo_id integer, cuenta_cargo character varying, cuenta_abono_id integer, cuenta_abono character varying, monto numeric, justificacion character varying, estado integer, fecha_creacion_nombre character varying, fecha_actualizacion_nombre character varying, creado_por_id integer, actualizado_por_id integer, creado_por_nombre character varying, actualizado_por_nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
SELECT tbpa.id_bit_presupuesto_ajuste ajuste_id,
tbpa.id_det_presupuesto  as det_presupuesto_id,
replace(tbpa.mes,'_final','') as mes,
tbpa.cuenta_cargo  as cuenta_cargo_id,
cuenta_cargo_nombre.nombre as cuenta_cargo,
tbpa.cuenta_abono as cuenta_abono_id,
cuenta_abono_nombre.nombre as cuenta_abono,
tbpa.monto,
tbpa.justificacion,
tbpa.estado,
to_char(tbpa.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion_nombre,
to_char(tbpa.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion_nombre,
tbpa.creado_por as creado_por_id,
tbpa.actualizado_por as actualizado_por_id,
cast(creado_por_nombre.nombre as varchar) as creado_por_nombre,
(modificado_por_nombre.nombre)::varchar as actualizado_por_nombre 
FROM compras_presupuesto.tbl_bit_presupuesto_ajuste tbpa
JOIN compras_presupuesto.tbl_det_presupuesto tdp
	ON tdp.id_det_presupuesto = tbpa.id_det_presupuesto
join compras_cuenta.tbl_cat_cuenta tcc 
	on tcc.id_cat_cuenta  = tdp.id_cat_cuenta 
LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tbpa.creado_por) creado_por_nombre ON true
LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tbpa.actualizado_por) modificado_por_nombre ON true
LEFT JOIN LATERAL (SELECT tcu5.nombre as nombre  FROM compras_cuenta.tbl_cat_cuenta tcu5 WHERE tcu5.id_cat_cuenta  = tbpa.cuenta_abono) cuenta_abono_nombre ON true
LEFT JOIN LATERAL (SELECT tcu6.nombre as nombre  FROM compras_cuenta.tbl_cat_cuenta tcu6 WHERE tcu6.id_cat_cuenta = tbpa.cuenta_cargo) cuenta_cargo_nombre ON true
 where (tbpa.cuenta_abono  = int_id_cuenta_abono  or int_id_cuenta_abono = 0)
and (tbpa.cuenta_cargo  = int_id_cuenta_cargo  or int_id_cuenta_cargo = 0)
and (tbpa.id_det_presupuesto  = int_id_det_presupuesto  or int_id_det_presupuesto = 0)
and (tbpa.creado_por  = int_id_cat_usuario_creado_por  or int_id_cat_usuario_creado_por = 0)
and (tbpa.actualizado_por  = int_id_cat_usuario_actualizado_por  or int_id_cat_usuario_actualizado_por = 0)
;
END;
$$;
 �   DROP FUNCTION compras_presupuesto.get_bit_presupuesto_ajuste(int_id_cuenta_abono integer, int_id_cuenta_cargo integer, int_id_det_presupuesto integer, int_id_cat_usuario_creado_por integer, int_id_cat_usuario_actualizado_por integer);
       compras_presupuesto          vince    false    20            �           1255    26633     get_detalle_presupuesto(integer)    FUNCTION     J  CREATE FUNCTION compras_presupuesto.get_detalle_presupuesto(int_id_cat_presupuesto integer) RETURNS TABLE(presupuesto_id_det integer, cuenta_id integer, cuenta_nombre character varying, monto_inicial numeric, monto_final numeric, enero_inicial numeric, enero_final numeric, febrero_inicial numeric, febrero_final numeric, marzo_inicial numeric, marzo_final numeric, abril_inicial numeric, abril_final numeric, mayo_inicial numeric, mayo_final numeric, junio_inicial numeric, junio_final numeric, julio_inicial numeric, julio_final numeric, agosto_inicial numeric, agosto_final numeric, septiembre_inicial numeric, septiembre_final numeric, octubre_inicial numeric, octubre_final numeric, noviembre_inicial numeric, noviembre_final numeric, diciembre_inicial numeric, diciembre_final numeric, estado integer, fecha_creacion_nombre character varying, fecha_actualizacion_nombre character varying, creado_por_id integer, actualizado_por_id integer, creado_por_nombre character varying, actualizado_por_nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
SELECT tdp.id_det_presupuesto presupuesto_id_det,
	tdp.id_cat_cuenta cuenta_id,
	tcc.nombre cuenta_nombre,
	tdp.monto_inicial monto_inicial,
	tdp.monto_final monto_final,
	tdp.enero_inicial,
	tdp.enero_final,
	tdp.febrero_inicial,
	tdp.febrero_final,
	tdp.marzo_inicial,
	tdp.marzo_final,
	tdp.abril_inicial,
	tdp.abril_final,
	tdp.mayo_inicial,
	tdp.mayo_final,
	tdp.junio_inicial,
	tdp.junio_final,
	tdp.julio_inicial,
	tdp.julio_final,
	tdp.agosto_inicial,
	tdp.agosto_final,
	tdp.septiembre_inicial,
	tdp.septiembre_final,
	tdp.octubre_inicial,
	tdp.octubre_final,
	tdp.noviembre_inicial,
	tdp.noviembre_final,
	tdp.diciembre_inicial,
	tdp.diciembre_final,
	tdp.estado,
	to_char(tdp.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion_nombre,
	to_char(tdp.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion_nombre,
	tdp.creado_por as creado_por_id,
	tdp.actualizado_por as actualizado_por_id,
	cast(creado_por_nombre.nombre as varchar) as creado_por_nombre,
	(modificado_por_nombre.nombre)::varchar as actualizado_por_nombre 
FROM compras_presupuesto.tbl_det_presupuesto tdp
JOIN compras_presupuesto.tbl_cat_presupuesto tcp
	ON tcp.id_cat_presupuesto = tdp.id_cat_presupuesto
JOIN compras_cuenta.tbl_cat_cuenta tcc
	ON tcc.id_cat_cuenta = tdp.id_cat_cuenta
LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tcp.creado_por) creado_por_nombre ON true
LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tcp.actualizado_por) modificado_por_nombre ON true

  where (tdp.id_cat_presupuesto  = int_id_cat_presupuesto  or int_id_cat_presupuesto = 0)
order by tdp.id_det_presupuesto asc
;
END;
$$;
 [   DROP FUNCTION compras_presupuesto.get_detalle_presupuesto(int_id_cat_presupuesto integer);
       compras_presupuesto          vince    false    20            �           1255    26571 3   get_presupuesto(integer, integer, integer, integer)    FUNCTION     V	  CREATE FUNCTION compras_presupuesto.get_presupuesto(int_id_cat_empresa integer, int_presupuesto_estado integer, int_creado_por integer, int_actualizado_por integer) RETURNS TABLE(presupuesto_id integer, empresa_id integer, empresa_nombre character varying, usuario_responsable_id integer, usuario_responsable character varying, presupuesto_nombre_id integer, presupuesto_nombre_estado character varying, monto numeric, "año" integer, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_id integer, actualizado_por_id integer, creado_por character varying, actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  
 select tcp.id_cat_presupuesto as presupuesto_id,
tcp.id_cat_empresa as empresa_id,
tce.nombre as empresa_nombre,
tcp.usuario_responsable as usuario_responsable_id,
tcu.nombre as usuario_responsable,
tcpe.id_cat_presupuesto_estado as presupuesto_nombre_id,
tcpe.nombre as presupuesto_nombre_estado,
tcp.monto,
tcp.año,
tcp.estado,
to_char(tcp.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion,
to_char(tcp.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion,
tcp.creado_por as creado_por_id,
tcp.actualizado_por as actualizado_por_id,
creado_por.nombre as creado_por,
modificado_por.nombre as actualizado_por
from compras_presupuesto.tbl_cat_presupuesto tcp 
join usuarios.tbl_cat_empresa tce 
on tce.id_cat_empresa  = tcp.id_cat_empresa 
join usuarios.tbl_cat_usuario tcu 
on tcu.id_cat_usuario  = tcp.usuario_responsable 
join compras_presupuesto.tbl_cat_presupuesto_estado tcpe 
on tcpe.id_cat_presupuesto_estado = tcp.id_cat_presupuesto_estado 
LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tcp.creado_por) creado_por ON true
LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tcp.actualizado_por) modificado_por ON TRUE
  where (tcp.id_cat_empresa  = int_id_cat_empresa  or int_id_cat_empresa = 0)
  and (tcp.id_cat_presupuesto_estado  = int_presupuesto_estado  or int_presupuesto_estado = 0)
and (tcp.creado_por  = int_creado_por  or int_creado_por = 0)
and (tcp.actualizado_por  = int_actualizado_por  or int_actualizado_por = 0)
order by tcp.id_cat_presupuesto asc
;
END;
$$;
 �   DROP FUNCTION compras_presupuesto.get_presupuesto(int_id_cat_empresa integer, int_presupuesto_estado integer, int_creado_por integer, int_actualizado_por integer);
       compras_presupuesto          vince    false    20            �           1255    26558 ;   get_presupuesto_estado(character varying, integer, integer)    FUNCTION     _  CREATE FUNCTION compras_presupuesto.get_presupuesto_estado(str_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer) RETURNS TABLE(estado_id integer, nombre character varying, descripcion character varying, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, actualizado_por_id integer, creado_por_id integer, creado_por character varying, actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  
  select tcpe.id_cat_presupuesto_estado  as estado_id,
  tcpe.nombre as nombre,
  tcpe.descripcion as descripcion,
  tcpe.estado,
  to_char(tcpe.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion,
  to_char(tcpe.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion,
  tcpe.actualizado_por actualizado_por_id,
  tcpe.creado_por as creado_por_id,
  creado_por.nombre as creado_por, 
  modificado_por.nombre as actualizado_por 
  from compras_presupuesto.tbl_cat_presupuesto_estado tcpe 
  LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tcpe.creado_por) creado_por ON true
  LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tcpe.actualizado_por) modificado_por ON TRUE
where (upper(tcpe.nombre) LIKE ('%' || upper(str_nombre)  || '%')::varchar or LENGTH (upper(str_nombre)) = 0)
and (tcpe.creado_por = int_id_creado_por  or int_id_creado_por = 0)
and (tcpe.actualizado_por = int_id_actualizado_por  or int_id_actualizado_por = 0)
;
END;
$$;
 �   DROP FUNCTION compras_presupuesto.get_presupuesto_estado(str_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer);
       compras_presupuesto          vince    false    20            �           1255    26612 p   sp_bit_presupuesto_ajuste_add(integer, character varying, integer, integer, numeric, character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_presupuesto.sp_bit_presupuesto_ajuste_add(IN det_presupuesto_id integer, IN str_mes character varying, IN int_cuenta_abono integer, IN int_cuenta_cargo integer, IN mnt_monto numeric, IN str_justificacion character varying, IN creado_por_id integer)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  INSERT INTO compras_presupuesto.tbl_bit_presupuesto_ajuste (
    id_det_presupuesto,
    mes,
    cuenta_abono,
    cuenta_cargo,
    monto,
    justificacion,
    estado,
    fecha_creacion,
    fecha_actualizacion,
    creado_por,
    actualizado_por
  )
  VALUES (
    det_presupuesto_id,
    str_mes,
    int_cuenta_abono,
    int_cuenta_cargo,
    mnt_monto,
    str_justificacion,
    1,
    NOW(),
    NOW(),
    creado_por_id,
    creado_por_id
  );

  -- Actualiza la columna correspondiente en la tabla tbl_det_presupuesto cargo
  EXECUTE format('UPDATE compras_presupuesto.tbl_det_presupuesto SET %I = %I - $1,fecha_actualizacion = now(),actualizado_por = $3,monto_final = monto_final - $1 WHERE  id_cat_cuenta = $2', str_mes, str_mes)
  USING mnt_monto,int_cuenta_cargo,creado_por_id;
 
 -- Actualiza la columna correspondiente en la tabla tbl_det_presupuesto abono
  EXECUTE format('UPDATE compras_presupuesto.tbl_det_presupuesto SET %I = %I + $1,fecha_actualizacion = now(),actualizado_por = $3,monto_final = monto_final + $1 WHERE  id_cat_cuenta = $2', str_mes, str_mes)
  USING mnt_monto,int_cuenta_abono,creado_por_id;
END;
$_$;
   DROP PROCEDURE compras_presupuesto.sp_bit_presupuesto_ajuste_add(IN det_presupuesto_id integer, IN str_mes character varying, IN int_cuenta_abono integer, IN int_cuenta_cargo integer, IN mnt_monto numeric, IN str_justificacion character varying, IN creado_por_id integer);
       compras_presupuesto          vince    false    20            �           1255    26559 L   sp_cat_presupuesto_add(integer, numeric, integer, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_presupuesto.sp_cat_presupuesto_add(IN empresa_id integer, IN nmc_monto numeric, IN "int_año" integer, IN responsable_id integer, IN presupuesto_id integer, IN creado_por_id integer)
    LANGUAGE plpgsql
    AS $$
begin
  
INSERT INTO compras_presupuesto.tbl_cat_presupuesto (
	id_cat_empresa
	,monto
	,año
	,usuario_responsable
	,id_cat_presupuesto_estado
	,estado
	,fecha_creacion
	,fecha_actualizacion
	,creado_por
	,actualizado_por
	)
VALUES (
	empresa_id
	,nmc_monto
	,int_año
	,responsable_id
	,1
	,presupuesto_id
	,now()
	,now()
	,creado_por_id
	,creado_por_id
	);

  
end
$$;
 �   DROP PROCEDURE compras_presupuesto.sp_cat_presupuesto_add(IN empresa_id integer, IN nmc_monto numeric, IN "int_año" integer, IN responsable_id integer, IN presupuesto_id integer, IN creado_por_id integer);
       compras_presupuesto          vince    false    20            �           1255    26556 L   sp_cat_presupuesto_estado_add(character varying, character varying, integer) 	   PROCEDURE       CREATE PROCEDURE compras_presupuesto.sp_cat_presupuesto_estado_add(IN str_nombre character varying, IN str_descripcion character varying, IN int_id_cat_usuario integer)
    LANGUAGE plpgsql
    AS $$
begin
  

INSERT INTO compras_presupuesto.tbl_cat_presupuesto_estado (
	nombre
	,descripcion
	,estado
	,fecha_creacion
	,fecha_actualizacion
	,creado_por
	,actualizado_por
	)
VALUES (
	str_nombre
	,str_descripcion
	,1
	,now()
	,now()
	,int_id_cat_usuario
	,int_id_cat_usuario
	);

  
end
$$;
 �   DROP PROCEDURE compras_presupuesto.sp_cat_presupuesto_estado_add(IN str_nombre character varying, IN str_descripcion character varying, IN int_id_cat_usuario integer);
       compras_presupuesto          vince    false    20            �           1255    26557 a   sp_cat_presupuesto_estado_update(integer, character varying, character varying, integer, integer) 	   PROCEDURE     ,  CREATE PROCEDURE compras_presupuesto.sp_cat_presupuesto_estado_update(IN int_id_cat_presupuesto_estado integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  

UPDATE compras_presupuesto.tbl_cat_presupuesto_estado
SET nombre=str_nombre,
descripcion=str_descripcion,
estado=int_estado,
fecha_actualizacion=now(),
actualizado_por=int_actualizado_por
WHERE id_cat_presupuesto_estado=int_id_cat_presupuesto_estado;

  
end
$$;
 �   DROP PROCEDURE compras_presupuesto.sp_cat_presupuesto_estado_update(IN int_id_cat_presupuesto_estado integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_actualizado_por integer);
       compras_presupuesto          vince    false    20            �           1255    26566 a   sp_cat_presupuesto_update(integer, integer, integer, integer, numeric, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_presupuesto.sp_cat_presupuesto_update(IN presupuesto_id integer, IN empresa_id integer, IN responsable_id integer, IN presupuesto_estado_id integer, IN nmc_monto numeric, IN "int_año" integer, IN int_estado integer, IN actualizado_por_id integer)
    LANGUAGE plpgsql
    AS $$
begin
  

UPDATE compras_presupuesto.tbl_cat_presupuesto
SET id_cat_empresa = empresa_id
	,monto = nmc_monto
	,año = int_año
	,usuario_responsable = responsable_id
	,id_cat_presupuesto_estado = presupuesto_estado_id
	,estado = int_estado
	,fecha_actualizacion = now()
	,actualizado_por = actualizado_por_id
WHERE id_cat_presupuesto = presupuesto_id;
  
end
$$;
   DROP PROCEDURE compras_presupuesto.sp_cat_presupuesto_update(IN presupuesto_id integer, IN empresa_id integer, IN responsable_id integer, IN presupuesto_estado_id integer, IN nmc_monto numeric, IN "int_año" integer, IN int_estado integer, IN actualizado_por_id integer);
       compras_presupuesto          vince    false    20            �           1255    26572   sp_det_presupuesto_add(integer, integer, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_presupuesto.sp_det_presupuesto_add(IN det_presupuesto_id integer, IN cuenta_id integer, IN nmc_monto_inicial numeric, IN nmc_monto_final numeric, IN nmc_enero_inicial numeric, IN nmc_enero_final numeric, IN nmc_febrero_inicial numeric, IN nmc_febrero_final numeric, IN nmc_marzo_inicial numeric, IN nmc_marzo_final numeric, IN nmc_abril_inicial numeric, IN nmc_abril_final numeric, IN nmc_mayo_inicial numeric, IN nmc_mayo_final numeric, IN nmc_junio_inicial numeric, IN nmc_junio_final numeric, IN nmc_julio_inicial numeric, IN nmc_julio_final numeric, IN nmc_agosto_inicial numeric, IN nmc_agosto_final numeric, IN nmc_septiembre_inicial numeric, IN nmc_septiembre_final numeric, IN nmc_octubre_inicial numeric, IN nmc_octubre_final numeric, IN nmc_noviembre_inicial numeric, IN nmc_noviembre_final numeric, IN nmc_diciembre_inicial numeric, IN nmc_diciembre_final numeric, IN creado_por_id integer)
    LANGUAGE plpgsql
    AS $$
begin
  
INSERT INTO compras_presupuesto.tbl_det_presupuesto (
	id_cat_presupuesto
	,id_cat_cuenta
	,monto_inicial
	,enero_inicial
	,enero_final
	,febrero_inicial
	,febrero_final
	,marzo_inicial
	,marzo_final
	,abril_inicial
	,abril_final
	,mayo_inicial
	,mayo_final
	,junio_inicial
	,junio_final
	,julio_inicial
	,julio_final
	,agosto_inicial
	,agosto_final
	,septiembre_inicial
	,septiembre_final
	,octubre_inicial
	,octubre_final
	,noviembre_inicial
	,noviembre_final
	,diciembre_inicial
	,diciembre_final
	,estado
	,fecha_creacion
	,fecha_actualizacion
	,creado_por
	,actualizado_por
	,monto_final
	)
VALUES (
	det_presupuesto_id
	,cuenta_id
	,nmc_monto_inicial
	,nmc_enero_inicial
	,nmc_enero_final
	,nmc_febrero_inicial
	,nmc_febrero_final
	,nmc_marzo_inicial
	,nmc_marzo_final
	,nmc_abril_inicial
	,nmc_abril_final
	,nmc_mayo_inicial
	,nmc_mayo_final
	,nmc_junio_inicial
	,nmc_junio_final
	,nmc_julio_inicial
	,nmc_julio_final
	,nmc_agosto_inicial
	,nmc_agosto_final
	,nmc_septiembre_inicial
	,nmc_septiembre_final
	,nmc_octubre_inicial
	,nmc_octubre_final
	,nmc_noviembre_inicial
	,nmc_noviembre_final
	,nmc_diciembre_inicial
	,nmc_diciembre_final
	,1
	,now()
	,now()
	,creado_por_id
	,creado_por_id
	,nmc_monto_final
	);
end
$$;
 �  DROP PROCEDURE compras_presupuesto.sp_det_presupuesto_add(IN det_presupuesto_id integer, IN cuenta_id integer, IN nmc_monto_inicial numeric, IN nmc_monto_final numeric, IN nmc_enero_inicial numeric, IN nmc_enero_final numeric, IN nmc_febrero_inicial numeric, IN nmc_febrero_final numeric, IN nmc_marzo_inicial numeric, IN nmc_marzo_final numeric, IN nmc_abril_inicial numeric, IN nmc_abril_final numeric, IN nmc_mayo_inicial numeric, IN nmc_mayo_final numeric, IN nmc_junio_inicial numeric, IN nmc_junio_final numeric, IN nmc_julio_inicial numeric, IN nmc_julio_final numeric, IN nmc_agosto_inicial numeric, IN nmc_agosto_final numeric, IN nmc_septiembre_inicial numeric, IN nmc_septiembre_final numeric, IN nmc_octubre_inicial numeric, IN nmc_octubre_final numeric, IN nmc_noviembre_inicial numeric, IN nmc_noviembre_final numeric, IN nmc_diciembre_inicial numeric, IN nmc_diciembre_final numeric, IN creado_por_id integer);
       compras_presupuesto          vince    false    20            �           1255    26575 0  sp_det_presupuesto_update(integer, integer, integer, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_presupuesto.sp_det_presupuesto_update(IN det_presupuesto_id integer, IN cat_presupuesto_id integer, IN cuenta_id integer, IN nmc_monto_inicial numeric, IN nmc_monto_final numeric, IN nmc_enero_inicial numeric, IN nmc_enero_final numeric, IN nmc_febrero_inicial numeric, IN nmc_febrero_final numeric, IN nmc_marzo_inicial numeric, IN nmc_marzo_final numeric, IN nmc_abril_inicial numeric, IN nmc_abril_final numeric, IN nmc_mayo_inicial numeric, IN nmc_mayo_final numeric, IN nmc_junio_inicial numeric, IN nmc_junio_final numeric, IN nmc_julio_inicial numeric, IN nmc_julio_final numeric, IN nmc_agosto_inicial numeric, IN nmc_agosto_final numeric, IN nmc_septiembre_inicial numeric, IN nmc_septiembre_final numeric, IN nmc_octubre_inicial numeric, IN nmc_octubre_final numeric, IN nmc_noviembre_inicial numeric, IN nmc_noviembre_final numeric, IN nmc_diciembre_inicial numeric, IN nmc_diciembre_final numeric, IN int_estado numeric, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
	
UPDATE compras_presupuesto.tbl_det_presupuesto
SET id_cat_presupuesto = cat_presupuesto_id
	,id_cat_cuenta = cuenta_id
	,monto_inicial = nmc_monto_inicial
	,enero_inicial = nmc_enero_inicial
	,enero_final = nmc_enero_final
	,febrero_inicial = nmc_febrero_inicial 
	,febrero_final = nmc_febrero_final
	,marzo_inicial = nmc_marzo_inicial 
	,marzo_final = nmc_marzo_final
	,abril_inicial = nmc_abril_inicial
	,abril_final = nmc_abril_final
	,mayo_inicial = nmc_mayo_inicial
	,mayo_final = nmc_mayo_final
	,junio_inicial = nmc_junio_inicial
	,junio_final = nmc_junio_final
	,julio_inicial = nmc_julio_inicial
	,julio_final = nmc_julio_final
	,agosto_inicial = nmc_agosto_inicial
	,agosto_final = nmc_agosto_final
	,septiembre_inicial = nmc_septiembre_inicial
	,septiembre_final = nmc_septiembre_final
	,octubre_inicial = nmc_octubre_inicial
	,octubre_final = nmc_octubre_final
	,noviembre_inicial = nmc_noviembre_inicial
	,noviembre_final = nmc_noviembre_final
	,diciembre_inicial = nmc_diciembre_inicial
	,diciembre_final = nmc_diciembre_final
	,estado = int_estado
	,fecha_actualizacion = now()
	,actualizado_por = int_actualizado_por
	,monto_final = nmc_monto_final
WHERE id_det_presupuesto = det_presupuesto_id;

end
$$;
 �  DROP PROCEDURE compras_presupuesto.sp_det_presupuesto_update(IN det_presupuesto_id integer, IN cat_presupuesto_id integer, IN cuenta_id integer, IN nmc_monto_inicial numeric, IN nmc_monto_final numeric, IN nmc_enero_inicial numeric, IN nmc_enero_final numeric, IN nmc_febrero_inicial numeric, IN nmc_febrero_final numeric, IN nmc_marzo_inicial numeric, IN nmc_marzo_final numeric, IN nmc_abril_inicial numeric, IN nmc_abril_final numeric, IN nmc_mayo_inicial numeric, IN nmc_mayo_final numeric, IN nmc_junio_inicial numeric, IN nmc_junio_final numeric, IN nmc_julio_inicial numeric, IN nmc_julio_final numeric, IN nmc_agosto_inicial numeric, IN nmc_agosto_final numeric, IN nmc_septiembre_inicial numeric, IN nmc_septiembre_final numeric, IN nmc_octubre_inicial numeric, IN nmc_octubre_final numeric, IN nmc_noviembre_inicial numeric, IN nmc_noviembre_final numeric, IN nmc_diciembre_inicial numeric, IN nmc_diciembre_final numeric, IN int_estado numeric, IN int_actualizado_por integer);
       compras_presupuesto          vince    false    20            �           1255    26863 &   sp_tbl_det_presupuesto_delete(integer) 	   PROCEDURE       CREATE PROCEDURE compras_presupuesto.sp_tbl_det_presupuesto_delete(IN int_det_presupuesto_id integer)
    LANGUAGE plpgsql
    AS $$
begin

DELETE FROM compras_presupuesto.tbl_det_presupuesto
WHERE id_det_presupuesto=int_det_presupuesto_id;
	
	end
$$;
 e   DROP PROCEDURE compras_presupuesto.sp_tbl_det_presupuesto_delete(IN int_det_presupuesto_id integer);
       compras_presupuesto          vince    false    20            �           1255    26610 +   update_column(text, text, numeric, integer)    FUNCTION     i  CREATE FUNCTION compras_presupuesto.update_column(p_table_name text, p_column_name text, p_value numeric, p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  query text;
BEGIN
  query := 'UPDATE ' || p_table_name || ' SET ' || p_column_name || ' = ' ||  p_value || ' WHERE id_det_presupuesto = ' || p_id || ';';
  EXECUTE query;
END;
$$;
 w   DROP FUNCTION compras_presupuesto.update_column(p_table_name text, p_column_name text, p_value numeric, p_id integer);
       compras_presupuesto          vince    false    20            �           1255    26909 n   get_cat_proveedor(character varying, character varying, character varying, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION compras_proveedor.get_cat_proveedor(str_nombre character varying, str_nit character varying, str_correo character varying, int_proveedor_tipo integer, int_proveedor_giro integer, int_id_creado_por integer, int_id_actualizado_por integer) RETURNS TABLE(id integer, nombre_completo character varying, giro_id integer, giro_nombre character varying, tipo_id integer, tipo_nombre character varying, usuario_id integer, usuario_nombre character varying, nit character varying, correo character varying, telefono integer, celular integer, rtu_archivo character varying, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_id integer, actualizado_por_id integer, creado_por character varying, actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
   select tcp.id_cat_proveedor as id,
 tcp.nombre_completo  as nombre_completo,
 tcp.id_cat_proveedor_giro as giro_id,
 tcpg.nombre as giro_nombre,
 tcp.id_cat_proveedor_tipo as tipo_id,
 tcpt.nombre as tipo_nombre,
 tcp.id_cat_usuario as usuario_id,
 tcu.nombre as usuario_nombre,
 tcp.nit as nit,
 tcp.email  as correo,
 tcp.telefono_contacto as telefono,
 tcp.celular_personal as celular,
 tcp.rtu_archivo as rtu_archivo,
 tcp.estado as estado,
 to_char(tcpt.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion,
 to_char(tcpt.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion,
 tcp.creado_por as creado_por_id,
 tcp.actualizado_por as actualizado_por_id,
 creado_por.nombre as creado_por,
 modificado_por.nombre as actualizado_por
 from compras_proveedor.tbl_cat_proveedor tcp 
 join compras_proveedor.tbl_cat_proveedor_giro tcpg 
 on tcpg.id_cat_proveedor_giro  = tcp.id_cat_proveedor_giro 
 join compras_proveedor.tbl_cat_proveedor_tipo tcpt 
 on tcpt.id_cat_proveedor_tipo  = tcp.id_cat_proveedor_tipo 
 join usuarios.tbl_cat_usuario tcu 
 on tcu.id_cat_usuario  = tcp.id_cat_usuario 
 LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tcp.creado_por) creado_por ON true
 LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tcp.actualizado_por) modificado_por ON true
 where (upper( tcp.nombre_completo) LIKE ('%' || upper(str_nombre)  || '%')::varchar or LENGTH (upper(str_nombre)) = 0)
 and (upper(tcp.nit) LIKE ('%' || upper(str_nit)  || '%')::varchar or LENGTH (upper(str_nit)) = 0)
  and (upper(tcp.email) LIKE ('%' || upper(str_correo)  || '%')::varchar or LENGTH (upper(str_correo)) = 0)
  and (tcp.id_cat_proveedor_tipo  = int_proveedor_tipo  or int_proveedor_tipo = 0)
  and (tcp.id_cat_proveedor_giro = int_proveedor_giro  or int_proveedor_giro = 0)
  and (tcp.creado_por = int_id_creado_por  or int_id_creado_por = 0)
  and (tcp.actualizado_por = int_id_actualizado_por  or int_id_actualizado_por = 0)
 
;
END;
$$;
 �   DROP FUNCTION compras_proveedor.get_cat_proveedor(str_nombre character varying, str_nit character varying, str_correo character varying, int_proveedor_tipo integer, int_proveedor_giro integer, int_id_creado_por integer, int_id_actualizado_por integer);
       compras_proveedor          vince    false    15            �           1255    26897 ;   get_cat_proveedor_giro(character varying, integer, integer)    FUNCTION       CREATE FUNCTION compras_proveedor.get_cat_proveedor_giro(str_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer) RETURNS TABLE(tipo_id integer, nombre character varying, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_id integer, actualizado_por_id integer, creado_por character varying, actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  select 
  tcpt.id_cat_proveedor_giro as tipo_id,
  tcpt.nombre  as nombre,
  tcpt.estado  as estado,
  to_char(tcpt.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion,
  to_char(tcpt.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion,
  tcpt.creado_por as creado_por_id,
  tcpt.actualizado_por as actualizado_por_id,
  creado_por.nombre as creado_por,
  modificado_por.nombre as actualizado_por
  from compras_proveedor.tbl_cat_proveedor_giro tcpt 
  LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tcpt.creado_por) creado_por ON true
  LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tcpt.actualizado_por) modificado_por ON true
  where (upper(tcpt.nombre) LIKE ('%' || upper(str_nombre)  || '%')::varchar or LENGTH (upper(str_nombre)) = 0)
  and (tcpt.creado_por = int_id_creado_por  or int_id_creado_por = 0)
  and (tcpt.actualizado_por = int_id_actualizado_por  or int_id_actualizado_por = 0)
;
END;
$$;
 �   DROP FUNCTION compras_proveedor.get_cat_proveedor_giro(str_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer);
       compras_proveedor          vince    false    15            �           1255    26851 ;   get_cat_proveedor_tipo(character varying, integer, integer)    FUNCTION     "  CREATE FUNCTION compras_proveedor.get_cat_proveedor_tipo(str_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer) RETURNS TABLE(tipo_id integer, nombre character varying, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_id integer, actualizado_por_id integer, creado_por character varying, actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  
  select 
  tcpt.id_cat_proveedor_tipo as tipo_id,
  tcpt.nombre  as nombre,
  tcpt.estado  as estado,
  to_char(tcpt.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion,
  to_char(tcpt.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion,
  tcpt.creado_por as creado_por_id,
  tcpt.actualizado_por as actualizado_por_id,
  creado_por.nombre as creado_por,
  modificado_por.nombre as actualizado_por
  from compras_proveedor.tbl_cat_proveedor_tipo tcpt 
  LEFT JOIN LATERAL (SELECT tcu3.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tcpt.creado_por) creado_por ON true
  LEFT JOIN LATERAL (SELECT tcu4.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tcpt.actualizado_por) modificado_por ON true
  where (upper(tcpt.nombre) LIKE ('%' || upper(str_nombre)  || '%')::varchar or LENGTH (upper(str_nombre)) = 0)
  and (tcpt.creado_por = int_id_creado_por  or int_id_creado_por = 0)
  and (tcpt.actualizado_por = int_id_actualizado_por  or int_id_actualizado_por = 0)
;
END;
$$;
 �   DROP FUNCTION compras_proveedor.get_cat_proveedor_tipo(str_nombre character varying, int_id_creado_por integer, int_id_actualizado_por integer);
       compras_proveedor          vince    false    15            �           1255    26905 �   sp_tbl_cat_proveedor_add(integer, integer, character varying, character varying, character varying, integer, integer, character varying, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_add(IN int_giro_id integer, IN int_tipo_id integer, IN str_nombre character varying, IN str_nit character varying, IN str_email character varying, IN int_telefono integer, IN int_celular integer, IN str_archivo character varying, IN int_creado_por integer, IN int_usuario_id integer)
    LANGUAGE plpgsql
    AS $$
begin
  
INSERT INTO compras_proveedor.tbl_cat_proveedor (
	id_cat_proveedor_giro,
	nombre_completo,
	nit,
	email,
	telefono_contacto,
	celular_personal,
	rtu_archivo,
	id_cat_proveedor_tipo,
	estado,
	fecha_creacion,
	fecha_actualizacion,
	creado_por,
	actualizado_por,
	id_cat_usuario
	)
VALUES (
	int_giro_id,
	str_nombre,
	str_nit,
	str_email,
	int_telefono,
	int_celular,
	str_archivo,
	int_tipo_id,
	1,
	now(),
	now(),
	int_creado_por,
	int_creado_por,
	int_usuario_id
	);

end
$$;
 S  DROP PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_add(IN int_giro_id integer, IN int_tipo_id integer, IN str_nombre character varying, IN str_nit character varying, IN str_email character varying, IN int_telefono integer, IN int_celular integer, IN str_archivo character varying, IN int_creado_por integer, IN int_usuario_id integer);
       compras_proveedor          vince    false    15            �           1255    26852 L   sp_tbl_cat_proveedor_giro_add(character varying, character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_giro_add(IN str_nombre character varying, IN str_descripcion character varying, IN int_creado_por integer)
    LANGUAGE plpgsql
    AS $$
begin

INSERT INTO compras_proveedor.tbl_cat_proveedor_giro (
	nombre,
	descripcion,
	estado,
	fecha_creacion,
	fecha_actualizacion,
	creado_por,
	actualizado_por
	)
VALUES (
	str_nombre,
	str_descripcion,
	1,
	now(),
	now(),
	int_creado_por,
	int_creado_por
	);
end
$$;
 �   DROP PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_giro_add(IN str_nombre character varying, IN str_descripcion character varying, IN int_creado_por integer);
       compras_proveedor          vince    false    15            �           1255    26864 a   sp_tbl_cat_proveedor_giro_update(integer, character varying, character varying, integer, integer) 	   PROCEDURE       CREATE PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_giro_update(IN int_giro_id integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
	
	UPDATE compras_proveedor.tbl_cat_proveedor_giro
SET nombre = str_nombre,
	descripcion = str_descripcion,
	estado = int_estado,
	fecha_actualizacion = now(),
	actualizado_por = int_actualizado_por
WHERE id_cat_proveedor_giro = int_giro_id;
	
end
$$;
 �   DROP PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_giro_update(IN int_giro_id integer, IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_actualizado_por integer);
       compras_proveedor          vince    false    15            �           1255    26848 9   sp_tbl_cat_proveedor_tipo_add(character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_tipo_add(IN str_nombre character varying, IN int_creado_por integer)
    LANGUAGE plpgsql
    AS $$
begin

INSERT INTO compras_proveedor.tbl_cat_proveedor_tipo (
	nombre,
	estado,
	fecha_creacion,
	fecha_actualizacion,
	creado_por,
	actualizado_por
	)
VALUES (
	str_nombre,
	1,
	now(),
	now(),
	int_creado_por,
	int_creado_por
	);
end
$$;
 |   DROP PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_tipo_add(IN str_nombre character varying, IN int_creado_por integer);
       compras_proveedor          vince    false    15            �           1255    26849 N   sp_tbl_cat_proveedor_tipo_update(integer, character varying, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_tipo_update(IN int_tipo_id integer, IN str_nombre character varying, IN int_estado integer, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
begin

UPDATE compras_proveedor.tbl_cat_proveedor_tipo
SET nombre = str_nombre,
	estado = int_estado,
	fecha_actualizacion = now(),
	actualizado_por = int_actualizado_por
WHERE id_cat_proveedor_tipo = int_tipo_id;
end
$$;
 �   DROP PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_tipo_update(IN int_tipo_id integer, IN str_nombre character varying, IN int_estado integer, IN int_actualizado_por integer);
       compras_proveedor          vince    false    15            �           1255    26910 �   sp_tbl_cat_proveedor_update(integer, integer, integer, character varying, character varying, character varying, integer, integer, character varying, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_update(IN int_proveedor_id integer, IN int_giro_id integer, IN int_tipo_id integer, IN str_nombre character varying, IN str_nit character varying, IN str_email character varying, IN int_telefono integer, IN int_celular integer, IN str_rtu character varying, IN int_estado integer, IN int_actualizado_por integer, IN int_id_cat_usuario integer)
    LANGUAGE plpgsql
    AS $$
begin
	
UPDATE compras_proveedor.tbl_cat_proveedor
SET id_cat_proveedor_giro = int_giro_id,
	nombre_completo = str_nombre,
	nit = str_nit,
	email = str_email,
	telefono_contacto = int_telefono,
	celular_personal = int_celular,
	rtu_archivo = str_rtu,
	id_cat_proveedor_tipo = int_tipo_id,
	estado = int_estado,
	fecha_actualizacion = now(),
	actualizado_por = int_actualizado_por,
	id_cat_usuario = int_id_cat_usuario
WHERE id_cat_proveedor = int_proveedor_id;
	
end
$$;
 �  DROP PROCEDURE compras_proveedor.sp_tbl_cat_proveedor_update(IN int_proveedor_id integer, IN int_giro_id integer, IN int_tipo_id integer, IN str_nombre character varying, IN str_nit character varying, IN str_email character varying, IN int_telefono integer, IN int_celular integer, IN str_rtu character varying, IN int_estado integer, IN int_actualizado_por integer, IN int_id_cat_usuario integer);
       compras_proveedor          vince    false    15            �           1255    26973 1   add_marcaje(character varying, character varying)    FUNCTION     �  CREATE FUNCTION general.add_marcaje(str_usuario character varying, str_accion character varying) RETURNS TABLE(id_registro integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	INSERT INTO general.tbl_bit_marcaje(
		id_bit_marcaje, 
		usuario, 
		accion)
	VALUES (nextval('general.tbl_bit_marcaje_id_bit_marcaje_seq'::regclass), 
			str_usuario, 
			str_accion)
	RETURNING general.tbl_bit_marcaje.id_bit_marcaje;
END
$$;
 `   DROP FUNCTION general.add_marcaje(str_usuario character varying, str_accion character varying);
       general          vince    false    13            �           1255    26977 C   add_marcaje(character varying, integer, integer, character varying)    FUNCTION     9  CREATE FUNCTION general.add_marcaje(str_usuario_nombre character varying, int_creado_por integer, int_actualizado_por integer, str_username character varying) RETURNS TABLE(id_cat_usuario integer, nombre character varying, id_ad character varying, correo character varying, user_principal_name character varying, telefono character varying, codigo_pais integer, tipo_pais integer, dominio_nombre character varying, dominio_id integer, categoria_nombre character varying, categoria_id integer, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_nombre character varying, creado_por_id integer, actualizado_por_nombre character varying, actualizado_por_id integer, username character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN 
  RETURN QUERY

  SELECT T_USUARIO.id_cat_usuario AS id_cat_usuario,
    T_USUARIO.nombre AS nombre,
    T_USUARIO.id_ad AS id_ad,
    T_USUARIO.correo AS correo,
    T_USUARIO.user_principal_name AS user_principal_name,
    T_USUARIO.telefono::VARCHAR AS telefono,
    T_USUARIO.codigo_pais AS codigo_pais,
    T_USUARIO.tipo_usuario AS tipo_pais,
    T_DOMINIO.nombre AS dominio_nombre,
    T_USUARIO.id_cat_usuario_dominio AS dominio_id,
    T_US_CATEGORIA.nombre AS categoria_nombre,
    T_US_CATEGORIA.id_cat_usuario_categoria AS categoria_id,
    T_USUARIO.estado AS estado,
    to_char(T_USUARIO.fecha_creacion,'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_creacion,
    to_char(T_USUARIO.fecha_actualizacion,'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_actualizacion,
    T_CREADO.nombre AS creado_por_nombre,
    T_USUARIO.creado_por AS creado_por_id,
    T_ACTUALIZADO.nombre AS actualizado_por_nombre,
    T_USUARIO.actualizado_por AS actualizado_por_id,
    T_USUARIO.username AS username
  
  FROM usuarios.tbl_cat_usuario T_USUARIO
    LEFT JOIN usuarios.tbl_cat_usuario_dominio T_DOMINIO ON T_USUARIO.id_cat_usuario_dominio = T_DOMINIO.id_cat_usuario_dominio
    LEFT JOIN usuarios.tbl_cat_usuario_categoria T_US_CATEGORIA ON T_US_CATEGORIA.id_cat_usuario_categoria = T_USUARIO.id_cat_usuario_categoria
    LEFT JOIN LATERAL (SELECT T_USUARIO2.nombre AS nombre FROM usuarios.tbl_cat_usuario T_USUARIO2 WHERE T_USUARIO2.id_cat_usuario = T_USUARIO.creado_por) T_CREADO ON true
    LEFT JOIN LATERAL (SELECT T_USUARIO2.nombre AS nombre FROM usuarios.tbl_cat_usuario T_USUARIO2 WHERE T_USUARIO2.id_cat_usuario = T_USUARIO.actualizado_por) T_ACTUALIZADO ON true
  
  WHERE 
    (UPPER(T_USUARIO.nombre) LIKE ('%' || UPPER(str_usuario_nombre) || '%')::VARCHAR OR LENGTH (UPPER(str_usuario_nombre)) = 0)
    AND (T_USUARIO.creado_por = int_creado_por OR int_creado_por = 0)
    AND (T_USUARIO.actualizado_por = int_actualizado_por OR int_actualizado_por = 0)
    AND (UPPER(T_USUARIO.username) LIKE ('%' || UPPER(str_username) || '%')::VARCHAR OR LENGTH (UPPER(str_username)) = 0);
END
$$;
 �   DROP FUNCTION general.add_marcaje(str_usuario_nombre character varying, int_creado_por integer, int_actualizado_por integer, str_username character varying);
       general          vince    false    13            �           1255    24614 �   sp_tbl_bit_reporte_consulta_add(character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     =  CREATE PROCEDURE general.sp_tbl_bit_reporte_consulta_add(IN str_usuario character varying, IN str_reporte character varying, IN str_fechai character varying, IN str_fechaf character varying, IN str_empresa character varying, IN str_cuenta character varying)
    LANGUAGE plpgsql
    AS $$
begin
    
	
	
INSERT INTO "general".tbl_bit_reporte_consulta
(usuario, reporte, fecha_hora, consulta)
VALUES(str_usuario , str_reporte , now(), JSONB_BUILD_OBJECT('fecha_inicio',str_fechaI , 'fecha_fin', str_fechaF,'empresa',str_Empresa,'cuenta',str_Cuenta));



end
$$;
   DROP PROCEDURE general.sp_tbl_bit_reporte_consulta_add(IN str_usuario character varying, IN str_reporte character varying, IN str_fechai character varying, IN str_fechaf character varying, IN str_empresa character varying, IN str_cuenta character varying);
       general          vince    false    13            �           1255    26779 �   sp_tbl_bit_reporte_consulta_add_general(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE general.sp_tbl_bit_reporte_consulta_add_general(IN str_usuario character varying, IN str_reporte character varying, IN str_desc1 character varying, IN str_desc2 character varying, IN str_desc3 character varying)
    LANGUAGE plpgsql
    AS $$
begin
    
	
INSERT INTO "general".tbl_bit_reporte_consulta
(usuario, reporte, fecha_hora, consulta)
VALUES(str_usuario , str_reporte , now(), JSONB_BUILD_OBJECT('minor_status',str_desc1 , 'major_status', str_desc2,'tipo_busqueda',str_desc3));


end
$$;
 �   DROP PROCEDURE general.sp_tbl_bit_reporte_consulta_add_general(IN str_usuario character varying, IN str_reporte character varying, IN str_desc1 character varying, IN str_desc2 character varying, IN str_desc3 character varying);
       general          vince    false    13            �           1255    25648 o   get_aplicacion_all(integer, character varying, integer, integer, integer, character varying, character varying)    FUNCTION     L  CREATE FUNCTION nova_aplicacion.get_aplicacion_all(int_cat_aplicacion integer, str_nombre character varying, int_estado integer, int_creado_por integer, int_modificado_por integer, str_fecha_creacion_i character varying, str_fecha_actualizacion_f character varying) RETURNS TABLE(id_cat_aplicacion integer, nombre character varying, descripcion character varying, estado integer, creado_por integer, modificado_por integer, fecha_creacion timestamp without time zone, fecha_actualizacion timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
SELECT apt.id_cat_aplicacion, apt.nombre, apt.descripcion , apt.estado, apt.creado_por, apt.modificado_por, apt.fecha_creacion , apt.fecha_actualizacion 
FROM nova_aplicacion.tbl_cat_aplicacion apt
where 
 (apt.id_cat_aplicacion  = int_cat_aplicacion or int_cat_aplicacion is null) 
 and (apt.nombre like  str_nombre  or str_nombre is null) 
 and  (apt.estado  = int_estado or int_estado is null) 
 and  (apt.creado_por  = int_creado_por or int_creado_por is null) 
 and  (apt.modificado_por  = int_modificado_por or int_modificado_por is null) 
and (to_char(apt.fecha_creacion , 'YYYY-MM-dd') >= str_fecha_creacion_i AND to_char(apt.fecha_creacion, 'YYYY-MM-dd') <= str_fecha_actualizacion_f or str_fecha_creacion_i is null and str_fecha_actualizacion_f is null);
END;
$$;
 	  DROP FUNCTION nova_aplicacion.get_aplicacion_all(int_cat_aplicacion integer, str_nombre character varying, int_estado integer, int_creado_por integer, int_modificado_por integer, str_fecha_creacion_i character varying, str_fecha_actualizacion_f character varying);
       nova_aplicacion          vince    false    8            �           1255    25680 g   sp_bit_aplicacion_registro_add(integer, integer, integer, integer, integer, integer, character varying) 	   PROCEDURE     �  CREATE PROCEDURE nova_aplicacion.sp_bit_aplicacion_registro_add(IN int_id_cat_usuario integer, IN int_id_cat_aplicacion integer, IN int_estado integer, IN int_creado_por integer, IN int_modificado_por integer, IN int_id_bit_tarea_registro integer, IN str_descripcion character varying)
    LANGUAGE plpgsql
    AS $$
begin
  
IF  ((
		
SELECT count(*)
FROM nova_aplicacion.tbl_bit_aplicacion_registro where id_cat_usuario = int_id_cat_usuario and id_cat_aplicacion = int_id_cat_aplicacion
and id_bit_tarea_registro = int_id_bit_tarea_registro and descripcion  = str_descripcion

		) <= 0) then
INSERT INTO nova_aplicacion.tbl_bit_aplicacion_registro
(id_cat_usuario, id_cat_aplicacion, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion, id_bit_tarea_registro, descripcion)
VALUES(int_id_cat_usuario, int_id_cat_aplicacion, int_estado, int_creado_por, int_modificado_por, now(), now(), int_id_bit_tarea_registro, str_descripcion);
end IF ;
  
end
$$;
   DROP PROCEDURE nova_aplicacion.sp_bit_aplicacion_registro_add(IN int_id_cat_usuario integer, IN int_id_cat_aplicacion integer, IN int_estado integer, IN int_creado_por integer, IN int_modificado_por integer, IN int_id_bit_tarea_registro integer, IN str_descripcion character varying);
       nova_aplicacion          vince    false    8            �           1255    25641 W   sp_nova_aplicacion_add(character varying, character varying, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE nova_aplicacion.sp_nova_aplicacion_add(IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_creado_por integer, IN int_modificado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
IF  ((
		
SELECT count(*)
FROM nova_aplicacion.tbl_cat_aplicacion where nombre = str_nombre

		) <= 0) then

INSERT INTO nova_aplicacion.tbl_cat_aplicacion
(id_cat_aplicacion ,nombre, descripcion, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion)
VALUES(nextval('nova_aplicacion.tbl_cat_aplicacion_id_cat_aplicacion_seq'::regclass),str_nombre, str_descripcion, int_estado, int_creado_por, int_modificado_por, now(), now());

	end IF ;
  
end
$$;
 �   DROP PROCEDURE nova_aplicacion.sp_nova_aplicacion_add(IN str_nombre character varying, IN str_descripcion character varying, IN int_estado integer, IN int_creado_por integer, IN int_modificado_por integer);
       nova_aplicacion          vince    false    8            �           1255    25523 �   sp_bit_dispositivo_diagnostico_add(integer, numeric, time without time zone, integer, numeric, numeric, numeric, numeric, integer, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE nova_dispositivo.sp_bit_dispositivo_diagnostico_add(IN id_cat_dispositivo integer, IN in_cpu_uso numeric, IN in_cpu_tiempo_activo time without time zone, IN in_cpu_tiempo_activo_dia integer, IN in_ram_disponible_mb numeric, IN in_disco_disponible_mb numeric, IN in_internet_descarga_mb numeric, IN in_internet_carga_mb numeric, IN in_internet_latencia_descarga_ms integer, IN in_internet_latencia_carga_ms integer, IN in_creado_por integer, IN in_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  

	INSERT INTO nova_dispositivo.tbl_bit_dispositivo_diagnostico
(
id_cat_dispositivo, 
cpu_uso, 
cpu_tiempo_activo, 
cpu_tiempo_activo_dia, 
ram_disponible_mb, 
disco_disponible_mb, 
internet_descarga_mb, 
internet_carga_mb, 
internet_latencia_descarga_ms, 
internet_latencia_carga_ms, 
creado_por, 
actualizado_por, 
fecha_creacion, 
fecha_actualizacion)
VALUES(
id_cat_dispositivo, 
in_cpu_uso, 
in_cpu_tiempo_activo, 
in_cpu_tiempo_activo_dia, 
in_ram_disponible_mb, 
in_disco_disponible_mb, 
in_internet_descarga_mb, 
in_internet_carga_mb, 
in_internet_latencia_descarga_ms, 
in_internet_latencia_carga_ms, 
in_creado_por, 
in_actualizado_por, 
now(), 
now());

  
end
$$;
 �  DROP PROCEDURE nova_dispositivo.sp_bit_dispositivo_diagnostico_add(IN id_cat_dispositivo integer, IN in_cpu_uso numeric, IN in_cpu_tiempo_activo time without time zone, IN in_cpu_tiempo_activo_dia integer, IN in_ram_disponible_mb numeric, IN in_disco_disponible_mb numeric, IN in_internet_descarga_mb numeric, IN in_internet_carga_mb numeric, IN in_internet_latencia_descarga_ms integer, IN in_internet_latencia_carga_ms integer, IN in_creado_por integer, IN in_actualizado_por integer);
       nova_dispositivo          vince    false    12            �           1255    25096   sp_tbl_cat_dispositivo_add(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, bit, timestamp without time zone, integer, integer) 	   PROCEDURE     <  CREATE PROCEDURE nova_dispositivo.sp_tbl_cat_dispositivo_add(IN str_hostname character varying, IN str_ip character varying, IN str_sistema_operativo character varying, IN str_cpu character varying, IN str_disco_primario_total character varying, IN str_disco_primario_tipo character varying, IN str_ram_total character varying, IN str_product_id character varying, IN dtm_ultimo_logueo timestamp without time zone, IN bit_estado bit, IN dtm_fecha_actualizacion timestamp without time zone, IN int_creado_por integer, IN int_modificado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
IF  ((
		select count(*) from nova_dispositivo.tbl_cat_dispositivo where hostname = str_hostname and ip  = str_ip
		) <= 0) then
	INSERT INTO nova_dispositivo.tbl_cat_dispositivo (
		hostname
		,ip
		,sistema_operativo
		,cpu_nombre
		,disco_primario_total
		,disco_primario_tipo
		,ram_total
		,product_id
		,ultimo_logueo
		,estado
		,fecha_creacion
		,fecha_actualizacion
		,creado_por
		,modificado_por
		)
	VALUES (
		str_hostname
		,str_ip
		,str_sistema_operativo
		,str_cpu
		,str_disco_primario_total
		,str_disco_primario_tipo
		,str_ram_total
		,str_product_id
		,dtm_ultimo_logueo
		,bit_estado
		,now()
		,dtm_fecha_actualizacion
		,int_creado_por
		,int_modificado_por
		);

	end IF ;
  
end
$$;
 #  DROP PROCEDURE nova_dispositivo.sp_tbl_cat_dispositivo_add(IN str_hostname character varying, IN str_ip character varying, IN str_sistema_operativo character varying, IN str_cpu character varying, IN str_disco_primario_total character varying, IN str_disco_primario_tipo character varying, IN str_ram_total character varying, IN str_product_id character varying, IN dtm_ultimo_logueo timestamp without time zone, IN bit_estado bit, IN dtm_fecha_actualizacion timestamp without time zone, IN int_creado_por integer, IN int_modificado_por integer);
       nova_dispositivo          vince    false    12            �           1255    25099 f   sp_tbl_cat_dispositivo_upd(character varying, character varying, timestamp without time zone, integer) 	   PROCEDURE     T  CREATE PROCEDURE nova_dispositivo.sp_tbl_cat_dispositivo_upd(IN str_hostname character varying, IN str_ip character varying, IN dtm_ultimo_logueo timestamp without time zone, IN int_modificado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
IF  ((
		select count(*) from nova_dispositivo.tbl_cat_dispositivo where hostname = str_hostname and ip  = str_ip
		) >= 0) then
	UPDATE nova_dispositivo.tbl_cat_dispositivo
SET ultimo_logueo=dtm_ultimo_logueo, fecha_actualizacion=now(), modificado_por=int_modificado_por
WHERE hostname=str_hostname and ip=str_ip;

	end IF ;
  
end
$$;
 �   DROP PROCEDURE nova_dispositivo.sp_tbl_cat_dispositivo_upd(IN str_hostname character varying, IN str_ip character varying, IN dtm_ultimo_logueo timestamp without time zone, IN int_modificado_por integer);
       nova_dispositivo          vince    false    12            �           1255    25137 u   sp_nova_horario_entrada(integer, integer, integer, timestamp without time zone, integer, timestamp without time zone) 	   PROCEDURE     G  CREATE PROCEDURE nova_horario.sp_nova_horario_entrada(IN int_id_cat_horario_accion integer, IN int_id_cat_dispositivo integer, IN int_id_cat_usuario integer, IN dtm_fecha_hora timestamp without time zone, IN int_creado_por integer, IN dtm_fecha_actualizacion timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
begin
  
IF  ((
		
SELECT count(*)
FROM nova_horario.tbl_det_horario_asignacion_dia tdhad
INNER JOIN nova_horario.tbl_det_horario_asignacion_usuario tdhau
	ON tdhad.id_det_horario_asignacion_usuario = tdhau.id_det_horario_asignacion_usuario
INNER JOIN nova_horario.tbl_cat_horario_accion tcha
	ON tcha.id_cat_horario_accion = tdhad.id_cat_horario_accion
LEFT JOIN nova_horario.tbl_bit_horario_marcaje tbhm
	ON tbhm.id_cat_horario_accion = tcha.id_cat_horario_accion
WHERE tbhm.id_cat_usuario = int_id_cat_usuario
	AND tbhm.id_cat_horario_accion = 1
	AND tbhm.fecha_creacion::DATE = NOW()::DATE

		) <= 0) then

INSERT INTO nova_horario.tbl_bit_horario_marcaje (
	id_cat_horario_accion
	,id_cat_dispositivo
	,id_cat_usuario
	,fecha_hora
	,creado_por
	,modificado_por
	,fecha_creacion
	,fecha_actuallizacion
	)
VALUES (
	int_id_cat_horario_accion
	,int_id_cat_dispositivo
	,int_id_cat_usuario
	,dtm_fecha_hora
	,int_creado_por
	,0
	,now()
	,dtm_fecha_actualizacion
	);

	end IF ;
  
end
$$;
   DROP PROCEDURE nova_horario.sp_nova_horario_entrada(IN int_id_cat_horario_accion integer, IN int_id_cat_dispositivo integer, IN int_id_cat_usuario integer, IN dtm_fecha_hora timestamp without time zone, IN int_creado_por integer, IN dtm_fecha_actualizacion timestamp without time zone);
       nova_horario          vince    false    11            �           1255    25142 t   sp_nova_horario_salida(integer, integer, integer, timestamp without time zone, integer, timestamp without time zone) 	   PROCEDURE     F  CREATE PROCEDURE nova_horario.sp_nova_horario_salida(IN int_id_cat_horario_accion integer, IN int_id_cat_dispositivo integer, IN int_id_cat_usuario integer, IN dtm_fecha_hora timestamp without time zone, IN int_creado_por integer, IN dtm_fecha_actualizacion timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
begin
  
IF  ((
		
SELECT count(*)
FROM nova_horario.tbl_det_horario_asignacion_dia tdhad
INNER JOIN nova_horario.tbl_det_horario_asignacion_usuario tdhau
	ON tdhad.id_det_horario_asignacion_usuario = tdhau.id_det_horario_asignacion_usuario
INNER JOIN nova_horario.tbl_cat_horario_accion tcha
	ON tcha.id_cat_horario_accion = tdhad.id_cat_horario_accion
LEFT JOIN nova_horario.tbl_bit_horario_marcaje tbhm
	ON tbhm.id_cat_horario_accion = tcha.id_cat_horario_accion
WHERE tbhm.id_cat_usuario = int_id_cat_usuario
	AND tbhm.id_cat_horario_accion = 2
	AND tbhm.fecha_creacion::DATE = NOW()::DATE

		) <= 0) then

INSERT INTO nova_horario.tbl_bit_horario_marcaje (
	id_cat_horario_accion
	,id_cat_dispositivo
	,id_cat_usuario
	,fecha_hora
	,creado_por
	,modificado_por
	,fecha_creacion
	,fecha_actuallizacion
	)
VALUES (
	int_id_cat_horario_accion
	,int_id_cat_dispositivo
	,int_id_cat_usuario
	,dtm_fecha_hora
	,int_creado_por
	,0
	,now()
	,dtm_fecha_actualizacion
	);

	end IF ;
  
end
$$;
   DROP PROCEDURE nova_horario.sp_nova_horario_salida(IN int_id_cat_horario_accion integer, IN int_id_cat_dispositivo integer, IN int_id_cat_usuario integer, IN dtm_fecha_hora timestamp without time zone, IN int_creado_por integer, IN dtm_fecha_actualizacion timestamp without time zone);
       nova_horario          vince    false    11            �           1255    25875 !   get_count_tareas_activas(integer)    FUNCTION     �  CREATE FUNCTION nova_proceso_tarea.get_count_tareas_activas(int_id_cat_usuario integer) RETURNS TABLE(tareas_contador_tareas_activas bigint, tareas_id_cat_tarea integer, tarea_nombre text, id_bit_tarea_registro integer, fecha_asignacion text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY

SELECT count(tbtr.id_bit_tarea_registro) AS tareas_contador_tareas_activas
	,tbtr.id_cat_tarea AS tareas_id_cat_tarea
	,trim(tct.nombre) AS tarea_nombre
	,tbtr.id_bit_tarea_registro
	,to_char(tbtr.inicio, 'YYYY-MM-DD HH:MI:SS') as fecha_asignacion 
FROM nova_proceso_tarea.tbl_bit_tarea_registro tbtr
JOIN nova_proceso_tarea.tbl_cat_tarea tct
	ON tct.id_cat_tarea = tbtr.id_cat_tarea
WHERE 
--tbtr.id_cat_usuario = 1
	(tbtr.id_cat_usuario  = int_id_cat_usuario  or int_id_cat_usuario = 0 )
	AND tbtr.fin IS NULL
GROUP BY tbtr.id_cat_tarea
	,tct.nombre
	,tbtr.id_bit_tarea_registro
	,tbtr.inicio 
;
END;
$$;
 W   DROP FUNCTION nova_proceso_tarea.get_count_tareas_activas(int_id_cat_usuario integer);
       nova_proceso_tarea          vince    false    7            �           1255    25876 6   get_count_tiempo_activo_x_dia_actual(integer, integer)    FUNCTION     \  CREATE FUNCTION nova_proceso_tarea.get_count_tiempo_activo_x_dia_actual(int_id_cat_usuario integer, int_id_cat_tarea integer) RETURNS TABLE(tiempo_en_tareas text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY

WITH tiempo_en_segundos AS (
   SELECT sum(DATE_PART('epoch', tbtr.fin  - tbtr.inicio)::integer) as diferencia_segundos 
FROM nova_proceso_tarea.tbl_bit_tarea_registro tbtr
JOIN nova_proceso_tarea.tbl_cat_tarea tct
	ON tct.id_cat_tarea = tbtr.id_cat_tarea
WHERE 
(tbtr.id_cat_usuario  = int_id_cat_usuario  or int_id_cat_usuario = 0 ) and 
(tbtr.id_cat_tarea  = int_id_cat_tarea  or int_id_cat_tarea = 0 ) AND tbtr.fin IS not null and to_date(to_char(tbtr.inicio, 'YYYY-MM-DD'),'YYYY-MM-DD') = current_date
), horas_minutos_segundos AS (
    SELECT 
    (diferencia_segundos/3600) AS horas,
    (diferencia_segundos % 3600 / 60) AS minutos,
    (diferencia_segundos % 60) AS segundos
    FROM tiempo_en_segundos
)
SELECT 
    to_char(horas, 'FM09') ||':'|| to_char(minutos, 'FM09') ||':'|| to_char(segundos, 'FM09') as tiempo_en_tareas 
FROM horas_minutos_segundos
;
END;
$$;
 }   DROP FUNCTION nova_proceso_tarea.get_count_tiempo_activo_x_dia_actual(int_id_cat_usuario integer, int_id_cat_tarea integer);
       nova_proceso_tarea          vince    false    7            �           1255    25877 7   get_count_tiempo_inactivo_x_dia_actual_usuario(integer)    FUNCTION     V  CREATE FUNCTION nova_proceso_tarea.get_count_tiempo_inactivo_x_dia_actual_usuario(int_id_cat_usuario integer) RETURNS TABLE(tareas_realizadas bigint, diferencia_segundos numeric, str_tiempo_activo text, tiempo_activo integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
	SELECT 
    count(*) AS tareas_realizadas,
    sum(tiempo_activo.diferencia_segundos) AS diferencia_segundos,
    CASE 
        WHEN sum(tiempo_activo.diferencia_segundos)::integer < 60 THEN sum(tiempo_activo.diferencia_segundos)::integer || ' segundos' 
        WHEN sum(tiempo_activo.diferencia_segundos)::integer >= 60 AND sum(tiempo_activo.diferencia_segundos)::integer < 3600 THEN (sum(tiempo_activo.diferencia_segundos)::integer/60)::integer || ' minutos'
        WHEN sum(tiempo_activo.diferencia_segundos)::integer >= 3600 THEN (sum(tiempo_activo.diferencia_segundos)::integer /3600) || ' horas'
    END AS str_tiempo_activo,
    CASE 
        WHEN sum(tiempo_activo.diferencia_segundos)::integer < 60 THEN sum(tiempo_activo.diferencia_segundos)::integer
        WHEN sum(tiempo_activo.diferencia_segundos)::integer >= 60 AND sum(tiempo_activo.diferencia_segundos)::integer < 3600 THEN (sum(tiempo_activo.diferencia_segundos)::integer/60)::integer
        WHEN sum(tiempo_activo.diferencia_segundos)::integer >= 3600 THEN (sum(tiempo_activo.diferencia_segundos)::integer /3600)
    END AS tiempo_activo
FROM nova_proceso_tarea.tbl_bit_tarea_registro tbtr
LEFT JOIN LATERAL(SELECT (sum(DATE_PART('epoch', tcu1.fin  - tcu1.inicio)::integer)) AS diferencia_segundos 
FROM nova_proceso_tarea.tbl_bit_tarea_registro tcu1 WHERE tcu1.id_bit_tarea_registro = tbtr.id_bit_tarea_registro) tiempo_activo
	ON true
WHERE tbtr.fin IS NOT NULL
	AND to_date(to_char(tbtr.inicio, 'YYYY-MM-DD'), 'YYYY-MM-DD') = CURRENT_DATE
	and tbtr.id_cat_usuario  =  int_id_cat_usuario
;
END;
$$;
 m   DROP FUNCTION nova_proceso_tarea.get_count_tiempo_inactivo_x_dia_actual_usuario(int_id_cat_usuario integer);
       nova_proceso_tarea          vince    false    7            �           1255    25815 .   sp_bit_proceso_tarea_fin_upd(integer, integer) 	   PROCEDURE     H  CREATE PROCEDURE nova_proceso_tarea.sp_bit_proceso_tarea_fin_upd(IN int_id_cat_usuario integer, IN int_id_bit_tarea_registro integer)
    LANGUAGE plpgsql
    AS $$
begin
  

UPDATE nova_proceso_tarea.tbl_bit_tarea_registro
SET  fin=now(), modificado_por=int_id_cat_usuario , fecha_actualizacion=now()
WHERE id_cat_tarea =int_id_bit_tarea_registro 
and id_bit_tarea_registro = (select max(tct.id_bit_tarea_registro) from nova_proceso_tarea.tbl_bit_tarea_registro tct where tct.id_cat_tarea = int_id_bit_tarea_registro and tct.id_cat_usuario = int_id_cat_usuario);

  
end
$$;
 �   DROP PROCEDURE nova_proceso_tarea.sp_bit_proceso_tarea_fin_upd(IN int_id_cat_usuario integer, IN int_id_bit_tarea_registro integer);
       nova_proceso_tarea          vince    false    7            �           1255    25684 U   sp_bit_tarea_registro_add(integer, integer, integer, date, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE nova_proceso_tarea.sp_bit_tarea_registro_add(IN int_id_cat_usuario integer, IN int_id_cat_tarea_estado integer, IN int_id_cat_tarea integer, IN dt_fecha date, IN int_estado integer, IN int_creado_por integer, IN int_modificado_por integer)
    LANGUAGE plpgsql
    AS $$
begin
  
INSERT INTO nova_proceso_tarea.tbl_bit_tarea_registro (
	id_cat_usuario
	,id_cat_tarea_estado
	,id_cat_tarea
	,fecha
	,inicio
	,fin
	,estado
	,creado_por
	,modificado_por
	,fecha_creacion
	,fecha_actualizacion
	)
VALUES (
	int_id_cat_usuario
	,int_id_cat_tarea_estado
	,int_id_cat_tarea
	,dt_fecha
	,now()
	,null
	,int_estado
	,int_creado_por
	,int_modificado_por
	,now()
	,now()
	);
  
end
$$;
    DROP PROCEDURE nova_proceso_tarea.sp_bit_tarea_registro_add(IN int_id_cat_usuario integer, IN int_id_cat_tarea_estado integer, IN int_id_cat_tarea integer, IN dt_fecha date, IN int_estado integer, IN int_creado_por integer, IN int_modificado_por integer);
       nova_proceso_tarea          vince    false    7            �           1255    25858 G   sp_tbl_cat_comentario_add(integer, character varying, integer, integer) 	   PROCEDURE     #  CREATE PROCEDURE nova_proceso_tarea.sp_tbl_cat_comentario_add(IN int_id_bit_tarea_registro integer, IN str_descripcion character varying, IN int_estado integer, IN int_id_cat_usuario integer)
    LANGUAGE plpgsql
    AS $$
begin
  
INSERT INTO nova_proceso_tarea.tbl_bit_tarea_comentario (
id_bit_tarea_registro,
descripcion,
estado,
fecha_creacion,
fecha_actualizacion,
creado_por,
modificador_por)
VALUES(
int_id_bit_tarea_registro,
str_descripcion,
int_estado,
now(),
now(),
int_id_cat_usuario,
int_id_cat_usuario);
end
$$;
 �   DROP PROCEDURE nova_proceso_tarea.sp_tbl_cat_comentario_add(IN int_id_bit_tarea_registro integer, IN str_descripcion character varying, IN int_estado integer, IN int_id_cat_usuario integer);
       nova_proceso_tarea          vince    false    7            �           1255    26925 �   add_ticket_primario(character varying, character varying, integer, integer, integer, integer, character varying, integer, integer, integer, integer, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION nova_ticket.add_ticket_primario(str_resumen character varying, str_descripcion character varying, int_id_cat_equipo integer, int_id_estado_proceso integer, int_estado_resolucion integer, int_id_responsable integer, str_ref_ticket_padre character varying, int_id_solicitante integer, int_id_cat_proceso integer, int_id_ticket_canal integer, int_id_ticket_prioridad integer, int_estado integer, int_creado_por integer, int_actualizado_por integer) RETURNS TABLE(referencia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
INSERT INTO nova_ticket.tbl_bit_ticket (
        id_bit_ticket,
        id_cat_ticket_tipo,
        referencia,
        resumen,
        descripcion,
        id_cat_equipo,
        id_cat_ticket_estado_proceso,
        id_cat_ticket_estado_resolucion,
        referencia_ticket_padre,
        fecha_asignacion,
        fecha_resolucion,
        fecha_ultima_vista,
        fecha_primera_respuesta,
        fecha_vencimiento,
        usuario_responsable,
        usuario_solicitante,
        id_cat_proceso,
        id_cat_ticket_canal,
        id_cat_ticket_prioridad,
        estado,
        creado_por,
        actualizado_por,
        fecha_creacion,
        fecha_actualizacion
    )
VALUES (
        nextval('nova_ticket.tbl_bit_ticket_id_bit_ticket_seq'::regclass),
        1,
        (
            SELECT (UPPER(SUBSTRING(emp.nombre, 1, 3)) || '-' || UPPER(SUBSTRING(tcd.nombre, 1, 3)) || '-' || UPPER(SUBSTRING(tce.nombre, 1, 3)) || '-' || contador.siguiente_correlativo) AS nombre_recomendado
            FROM usuarios.tbl_cat_equipo AS tce
	        JOIN usuarios.tbl_cat_departamento AS tcd ON tcd.id_cat_departamento = tce.id_cat_departamento
	        JOIN usuarios.tbl_cat_empresa AS emp ON tcd.id_cat_empresa = emp.id_cat_empresa
	        LEFT JOIN LATERAL (
		        SELECT (
				CASE
					WHEN COUNT(*) = 0 THEN 1
					ELSE COUNT(*) + 1
				END
			    )::INTEGER::VARCHAR AS siguiente_correlativo
		    FROM nova_ticket.tbl_bit_ticket AS tbt
			JOIN usuarios.tbl_cat_departamento tcd2 ON tcd2.id_cat_departamento = tce.id_cat_departamento
		    
            WHERE tbt.id_cat_ticket_tipo = 1
			AND tbt.id_cat_equipo = int_id_cat_equipo
			AND tcd2.id_cat_departamento = tcd.id_cat_departamento
	        ) AS contador ON true
            
            WHERE tce.id_cat_equipo = int_id_cat_equipo
            LIMIT 1
        ),
        str_resumen,
        str_descripcion,
        int_id_cat_equipo,
        int_id_estado_proceso,
        int_estado_resolucion,
        null,   /*referencia_ticket_padre*/
        null,   /*fecha_asignacion*/
        null,   /*fecha_resolucion*/
        null,   /*fecha_ultima_vista*/
        null,   /*fecha_primera_respuesta*/
        null,   /*fecha_vencimiento*/
        int_id_responsable,     /*usuario_responsable*/
        int_id_solicitante,     /*usuario_solicitante*/
        null,                   /*int_id_cat_proceso*/
        int_id_ticket_canal,    /*id_cat_ticket_canal*/
        int_id_ticket_prioridad,/*id_cat_ticket_prioridad*/
        int_estado,
        int_creado_por,
        int_actualizado_por,
        now(),
        now()
    )
RETURNING nova_ticket.tbl_bit_ticket.referencia;
END
$$;
 �  DROP FUNCTION nova_ticket.add_ticket_primario(str_resumen character varying, str_descripcion character varying, int_id_cat_equipo integer, int_id_estado_proceso integer, int_estado_resolucion integer, int_id_responsable integer, str_ref_ticket_padre character varying, int_id_solicitante integer, int_id_cat_proceso integer, int_id_ticket_canal integer, int_id_ticket_prioridad integer, int_estado integer, int_creado_por integer, int_actualizado_por integer);
       nova_ticket          vince    false    14            �           1255    25883 .   get_referencia_ticket_creado(integer, integer)    FUNCTION     �  CREATE FUNCTION nova_ticket.get_referencia_ticket_creado(int_id_cat_tipo integer, int_creado_por integer) RETURNS TABLE(referencia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
SELECT tbt.referencia AS referencia
FROM nova_ticket.tbl_bit_ticket tbt
WHERE tbt.id_cat_ticket_tipo = int_id_cat_tipo
	AND tbt.creado_por = int_creado_por
ORDER BY tbt.id_bit_ticket DESC limit 1
;
END;
$$;
 i   DROP FUNCTION nova_ticket.get_referencia_ticket_creado(int_id_cat_tipo integer, int_creado_por integer);
       nova_ticket          vince    false    14            �           1255    25881 �   sp_set_subticket(character varying, character varying, integer, integer, integer, integer, character varying, integer, integer, integer, integer, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE nova_ticket.sp_set_subticket(IN str_resumen character varying, IN str_descripcion character varying, IN int_id_cat_equipo integer, IN int_id_estado_proceso integer, IN int_estado_resolucion integer, IN int_id_responsable integer, IN str_ref_ticket_padre character varying, IN int_id_solicitante integer, IN int_id_cat_proceso integer, IN int_id_ticket_canal integer, IN int_id_ticket_prioridad integer, IN int_estado integer, IN int_creado_por integer, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO nova_ticket.tbl_bit_ticket (
        id_bit_ticket,
        id_cat_ticket_tipo,
        referencia,
        resumen,
        descripcion,
        id_cat_equipo,
        id_cat_ticket_estado_proceso,
        id_cat_ticket_estado_resolucion,
        referencia_ticket_padre,
        fecha_asignacion,
        fecha_resolucion,
        fecha_ultima_vista,
        fecha_primera_respuesta,
        fecha_vencimiento,
        usuario_responsable,
        usuario_solicitante,
        id_cat_proceso,
        id_cat_ticket_canal,
        id_cat_ticket_prioridad,
        estado,
        creado_por,
        actualizado_por,
        fecha_creacion,
        fecha_actualizacion
    )
VALUES (
        nextval(
            'nova_ticket.tbl_bit_ticket_id_bit_ticket_seq'::regclass
        ),
        1,
(
            SELECT (
                    upper(substring(tcd.nombre, 1, 3)) || '-' || upper(substring(tce.nombre, 1, 3))
                ) || '-' || contador.siguiente_correlativo AS nombre_recomendado
            FROM usuarios.get_equipo_usuario(int_id_responsable, int_id_cat_equipo) AS fnc
                JOIN usuarios.tbl_cat_equipo tce ON tce.id_cat_equipo = fnc.equipo_id
                JOIN usuarios.tbl_cat_departamento tcd ON tcd.id_cat_departamento = tce.id_cat_departamento
                LEFT JOIN LATERAL(
                    SELECT (
                            CASE
                                WHEN count(*) = 0 THEN 1
                                ELSE count(*) + 1
                            END
                        )::INTEGER::VARCHAR AS siguiente_correlativo
                    FROM nova_ticket.tbl_bit_ticket tbt JOIN usuarios.tbl_cat_departamento tcd2 
                    ON tcd2.id_cat_departamento = tce.id_cat_departamento
                    WHERE tbt.id_cat_ticket_tipo = 1
                        AND tbt.id_cat_equipo = tce.id_cat_equipo
                        AND tcd2.id_cat_departamento = tcd.id_cat_departamento
                ) contador ON true
        ),
        str_resumen,
        str_descripcion,
        int_id_cat_equipo,
        int_id_estado_proceso,
        int_estado_resolucion,
        null,
        now(),
        null,
        null,
        null,
        null,
        int_id_responsable,
        int_id_solicitante,
        int_id_cat_proceso,
        int_id_ticket_canal,
        int_id_ticket_prioridad,
        int_estado,
        int_creado_por,
        int_actualizado_por,
        now(),
        now()
    )
RETURNING id_bit_ticket;
END
$$;
 �  DROP PROCEDURE nova_ticket.sp_set_subticket(IN str_resumen character varying, IN str_descripcion character varying, IN int_id_cat_equipo integer, IN int_id_estado_proceso integer, IN int_estado_resolucion integer, IN int_id_responsable integer, IN str_ref_ticket_padre character varying, IN int_id_solicitante integer, IN int_id_cat_proceso integer, IN int_id_ticket_canal integer, IN int_id_ticket_prioridad integer, IN int_estado integer, IN int_creado_por integer, IN int_actualizado_por integer);
       nova_ticket          vince    false    14            �           1255    25882 �   sp_set_ticket_padre(character varying, character varying, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE nova_ticket.sp_set_ticket_padre(IN str_resumen character varying, IN str_descripcion character varying, IN int_id_cat_equipo integer, IN int_id_estado_proceso integer, IN int_estado_resolucion integer, IN int_id_responsable integer, IN int_id_solicitante integer, IN int_id_cat_proceso integer, IN int_id_ticket_canal integer, IN int_id_ticket_prioridad integer, IN int_estado integer, IN int_creado_por integer, IN int_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$BEGIN
INSERT INTO nova_ticket.tbl_bit_ticket (
        id_bit_ticket,
        id_cat_ticket_tipo,
        referencia,
        resumen,
        descripcion,
        id_cat_equipo,
        id_cat_ticket_estado_proceso,
        id_cat_ticket_estado_resolucion,
        referencia_ticket_padre,
        fecha_asignacion,
        fecha_resolucion,
        fecha_ultima_vista,
        fecha_primera_respuesta,
        fecha_vencimiento,
        usuario_responsable,
        usuario_solicitante,
        id_cat_proceso,
        id_cat_ticket_canal,
        id_cat_ticket_prioridad,
        estado,
        creado_por,
        actualizado_por,
        fecha_creacion,
        fecha_actualizacion
    )
VALUES (
        nextval(
            'nova_ticket.tbl_bit_ticket_id_bit_ticket_seq'::regclass
        ),
        1,
(
            SELECT (
                    upper(substring(tcd.nombre, 1, 3)) || '-' || upper(substring(tce.nombre, 1, 3))
                ) || '-' || contador.siguiente_correlativo AS nombre_recomendado
            FROM usuarios.get_equipo_usuario(int_id_responsable, int_id_cat_equipo) AS fnc
                JOIN usuarios.tbl_cat_equipo tce ON tce.id_cat_equipo = fnc.equipo_id
                JOIN usuarios.tbl_cat_departamento tcd ON tcd.id_cat_departamento = tce.id_cat_departamento
                LEFT JOIN LATERAL(
                    SELECT (
                            CASE
                                WHEN count(*) = 0 THEN 1
                                ELSE count(*) + 1
                            END
                        )::INTEGER::VARCHAR AS siguiente_correlativo
                    FROM nova_ticket.tbl_bit_ticket tbt JOIN usuarios.tbl_cat_departamento tcd2 
                    ON tcd2.id_cat_departamento = tce.id_cat_departamento
                    WHERE tbt.id_cat_ticket_tipo = 1
                        AND tbt.id_cat_equipo = tce.id_cat_equipo
                        AND tcd2.id_cat_departamento = tcd.id_cat_departamento
                ) contador ON true
        ),
        str_resumen,
        str_descripcion,
        int_id_cat_equipo,
        int_id_estado_proceso,
        int_estado_resolucion,
        null,
        now(),
        null,
        null,
        null,
        null,
        int_id_responsable,
        int_id_solicitante,
        int_id_cat_proceso,
        int_id_ticket_canal,
        int_id_ticket_prioridad,
        int_estado,
        int_creado_por,
        int_actualizado_por,
        now(),
        now()
    )
RETURNING id_bit_ticket;
END$$;
 �  DROP PROCEDURE nova_ticket.sp_set_ticket_padre(IN str_resumen character varying, IN str_descripcion character varying, IN int_id_cat_equipo integer, IN int_id_estado_proceso integer, IN int_estado_resolucion integer, IN int_id_responsable integer, IN int_id_solicitante integer, IN int_id_cat_proceso integer, IN int_id_ticket_canal integer, IN int_id_ticket_prioridad integer, IN int_estado integer, IN int_creado_por integer, IN int_actualizado_por integer);
       nova_ticket          vince    false    14            �           1255    26938 �   add_usuario(character varying, character varying, character varying, integer, character varying, integer, integer, integer, integer, integer, integer, character varying)    FUNCTION       CREATE FUNCTION usuarios.add_usuario(str_nombre character varying, str_id_ad character varying, str_correo character varying, int_creado_por integer, str_user_principal_name character varying, bit_apagado_automatico integer, int_telefono integer, int_codigo_pais integer, int_id_cat_usuario_dominio integer, int_tipo_usuario integer, int_id_cat_usuario_categoria integer, str_username character varying) RETURNS TABLE(id_usuario integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	INSERT INTO usuarios.tbl_cat_usuario(
        id_cat_usuario,
        nombre,
		id_ad,
		correo,
		estado,
		fecha_creacion,
		fecha_actualizacion,
		creado_por,
		actualizado_por,
		user_principal_name,
		apagado_automatico,
		telefono,
		codigo_pais,
		id_cat_usuario_dominio,
		tipo_usuario,
		id_cat_usuario_categoria,
		username
    )
	VALUES (
        nextval('usuarios.tbl_cat_usuario_id_cat_usuario_seq'::regclass)
		,str_nombre
		,str_id_ad
		,str_correo
		,1
		,now()
		,now()
		,int_creado_por
		,int_creado_por
		,str_user_principal_name
		,CASE WHEN bit_apagado_automatico = 0 THEN B'0' ELSE B'1' END
		,int_telefono
		,int_codigo_pais
		,int_id_cat_usuario_dominio
		,int_tipo_usuario
		,int_id_cat_usuario_categoria
		,str_username
    )	
	RETURNING usuarios.tbl_cat_usuario.id_cat_usuario;
END
$$;
 �  DROP FUNCTION usuarios.add_usuario(str_nombre character varying, str_id_ad character varying, str_correo character varying, int_creado_por integer, str_user_principal_name character varying, bit_apagado_automatico integer, int_telefono integer, int_codigo_pais integer, int_id_cat_usuario_dominio integer, int_tipo_usuario integer, int_id_cat_usuario_categoria integer, str_username character varying);
       usuarios          vince    false    6            �            1259    23896    tbl_cat_usuario    TABLE     �  CREATE TABLE usuarios.tbl_cat_usuario (
    id_cat_usuario integer NOT NULL,
    nombre character varying(450) DEFAULT NULL::character varying,
    id_ad character varying(600),
    correo character varying(250),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer,
    user_principal_name character varying(250),
    apagado_automatico bit(1),
    telefono integer,
    codigo_pais integer,
    id_cat_usuario_dominio integer,
    tipo_usuario integer,
    id_cat_usuario_categoria integer,
    username character varying(20)
);
 %   DROP TABLE usuarios.tbl_cat_usuario;
       usuarios         heap    vince    false    6            �           1255    25589     fngetuserbyidcatusuario(integer)    FUNCTION     �   CREATE FUNCTION usuarios.fngetuserbyidcatusuario(userid integer) RETURNS SETOF usuarios.tbl_cat_usuario
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM usuarios.tbl_cat_usuario tcu2
  WHERE tcu2.id_cat_usuario = UserId;
END;
$$;
 @   DROP FUNCTION usuarios.fngetuserbyidcatusuario(userid integer);
       usuarios          vince    false    6    232            �           1255    25830    get_asignacion_equipo(integer)    FUNCTION     T  CREATE FUNCTION usuarios.get_asignacion_equipo(int_id_cat_puesto integer) RETURNS TABLE(id_det_puesto_asignacion_equipo integer, puesto_nombre character varying, puesto_id_cat_puesto integer, equipo_nombre character varying, equipo_id_equipo integer, asignacion_equipo_estado integer, asignacion_fecha_creacion character varying, asignacion_fecha_actualizacion character varying, asignacion_creado_por integer, asignacion_nombre_creado_por character varying, asignacion_actualizado_por integer, asignacion_nombre_actualizado_por character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select 
tdpae.id_det_puesto_asignacion_equipo,
tcp.nombre as puesto_nombre,
tcp.id_cat_puesto as puesto_id_cat_puesto,
tce.nombre as equipo_nombre,
tce.id_cat_equipo as equipo_id_equipo,
tce.estado as asignacion_equipo_estado,
to_char(tce.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as asignacion_fecha_creacion,
to_char(tce.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as asignacion_fecha_actualizacion,
tce.creado_por as asignacion_creado_por,
nombre_creado_por.nombre as asignacion_nombre_creado_por,
tce.actualizado_por as asignacion_actualizado_por,
nombre_actualizado_por.nombre as asignacion_nombre_actualizado_por
from usuarios.tbl_det_puesto_asignacion_equipo tdpae 
join usuarios.tbl_cat_equipo tce 
on tdpae.id_cat_equipo = tce.id_cat_equipo 
join usuarios.tbl_cat_puesto tcp 
on tcp.id_cat_puesto = tdpae.id_cat_puesto 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tce.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tce.actualizado_por) nombre_actualizado_por ON true
where (tcp.id_cat_puesto = int_id_cat_puesto or int_id_cat_puesto = 0)
;
END;
$$;
 I   DROP FUNCTION usuarios.get_asignacion_equipo(int_id_cat_puesto integer);
       usuarios          vince    false    6            �           1255    25840 %   get_departamento_responsable(integer)    FUNCTION     A	  CREATE FUNCTION usuarios.get_departamento_responsable(int_id_cat_departamento integer) RETURNS TABLE(id_det_departamento_asignacion_responsable integer, departamento_nombre character varying, departamento_id_cat_departamento integer, departamento_id_cat_responsable integer, departamento_nombre_responsable character varying, departamento_responsable_estado integer, departamento_responsable_fecha_creacion character varying, departemento_responsable_fecha_actualizacion character varying, departamento_responsable_creado_por character varying, departamento_responsable_id_creado_por integer, departamento_responsable_actualizado_por character varying, departamento_responsable_id_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select 
tddar.id_det_departamento_asignacion_responsable 
,tdear.nombre as departamento_nombre
,tdear.id_cat_departamento  as departamento_id_cat_departamento
,tddar.id_cat_usuario as departamento_id_cat_responsable
,nombre_usuario.nombre as departamento_nombre_responsable
,tddar.estado as departamento_responsable_estado
,to_char(tddar.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as departamento_responsable_fecha_creacion
,to_char(tddar.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as departemento_responsable_fecha_actualizacion
,nombre_creado_por.nombre as departamento_responsable_creado_por
,tddar.creado_por  as departamento_responsable_id_creado_por
,nombre_actualizado_por.nombre as departamento_responsable_actualizado_por
,tddar.actualizado_por  as departamento_responsable_id_actualizado_por
from usuarios.tbl_det_departamento_asignacion_responsable tddar 
left join usuarios.tbl_cat_departamento tdear 
on tddar.id_cat_departamento  = tdear.id_cat_departamento 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tddar.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tddar.actualizado_por ) nombre_actualizado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tddar.id_cat_usuario  ) nombre_usuario ON true
where
(tddar.id_cat_departamento   = int_id_cat_departamento  or int_id_cat_departamento = 0 )
;

END;
$$;
 V   DROP FUNCTION usuarios.get_departamento_responsable(int_id_cat_departamento integer);
       usuarios          vince    false    6            �           1255    25836 ?   get_departamentos(character varying, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION usuarios.get_departamentos(str_departamento_nombre character varying, int_creado_por integer, int_actualizado_por integer, int_id_cat_empresa integer) RETURNS TABLE(departamento_id_cat_departamento integer, departamento_nombre character varying, empresa_id_cat_empresa integer, empresa_nombre_empresa character varying, departamento_id_estado integer, departamento_fecha_creacion character varying, departamento_fecha_actualizacion character varying, departamento_nombre_creado_por character varying, departamento_id_creado_por integer, departamento_nombre_actualizado_por character varying, departamento_id_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select tcd.id_cat_departamento  as departamento_id_cat_departamento,
tcd.nombre as departamento_nombre,
tcd.id_cat_empresa as empresa_id_cat_empresa,
nombre_empresa.nombre as empresa_nombre_empresa,
tcd.estado as departamento_id_estado,
to_char(tcd.fecha_creacion , 'YYYY-MM-DD HH:MI:SS AM')::varchar asdepartamento_fecha_creacion,
to_char(tcd.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as departamento_fecha_actualizacion,
nombre_creado_por.nombre as empresa_nombre_creado_por,
tcd.creado_por as departamento_id_creado_por,
nombre_actualizado_por.nombre as departamento_nombre_actualizado_por,
tcd.actualizado_por as departamento_id_actualizado_por
from usuarios.tbl_cat_departamento tcd 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_empresa tcu2 WHERE tcu2.id_cat_empresa = tcd.id_cat_empresa) nombre_empresa ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tcd.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tcd.actualizado_por) nombre_actualizado_por ON true
where (upper(tcd.nombre) LIKE ('%' || upper(str_departamento_nombre)  || '%')::varchar or LENGTH (upper(str_departamento_nombre)) = 0)
and (tcd.creado_por = int_creado_por  or int_creado_por = 0)
and (tcd.actualizado_por = int_actualizado_por  or int_actualizado_por = 0)
and (tcd.id_cat_empresa = int_id_cat_empresa  or int_id_cat_empresa = 0)
;
END;
$$;
 �   DROP FUNCTION usuarios.get_departamentos(str_departamento_nombre character varying, int_creado_por integer, int_actualizado_por integer, int_id_cat_empresa integer);
       usuarios          vince    false    6            �           1255    25832 )   get_empresa_responsable(integer, integer)    FUNCTION      	  CREATE FUNCTION usuarios.get_empresa_responsable(int_id_cat_usuario integer, int_id_cat_empresa integer) RETURNS TABLE(id_det_empresa_asignacion_responsable integer, empresa_nombre character varying, empresa_id_cat_empresa integer, empresa_id_responsable integer, empresa_nombre_usuario_responsable character varying, asignacion_responsable_estado integer, asignacion_responsable_fecha_creacion character varying, asignacion_responsable_fecha_actualizacion character varying, asignacion_responsable_creado_por character varying, asignacion_responsable_id_creado_por integer, asignacion_responsable_actualizado_por character varying, asignacion_responsable_id_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select 
tdear.id_det_empresa_asignacion_responsable 
,tce.nombre as empresa_nombre
,tdear.id_cat_empresa as empresa_id_cat_empresa
,tdear.id_cat_usuario as empresa_id_responsable
,nombre_usuario.nombre as empresa_nombre_usuario_responsable
,tdear.estado as asignacion_responsable_estado
,to_char(tdear.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as asignacion_responsable_fecha_creacion
,to_char(tdear.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as asignacion_responsable_fecha_actualizacion
,nombre_creado_por.nombre as asignacion_responsable_creado_por
,tdear.creado_por  as asignacion_responsable_id_creado_por
,nombre_actualizado_por.nombre as asignacion_responsable_actualizado_por
,tdear.actualizado_por  as asignacion_responsable_id_actualizado_por
from usuarios.tbl_cat_empresa tce 
left join usuarios.tbl_det_empresa_asignacion_responsable tdear 
on tce.id_cat_empresa = tdear.id_cat_empresa 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tdear.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tdear.actualizado_por ) nombre_actualizado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tdear.id_cat_usuario  ) nombre_usuario ON true
where
(tdear.id_cat_usuario   = int_id_cat_usuario  or int_id_cat_usuario = 0 )
and (tdear.id_cat_empresa  = int_id_cat_empresa or int_id_cat_empresa = 0 )
;

END;
$$;
 h   DROP FUNCTION usuarios.get_empresa_responsable(int_id_cat_usuario integer, int_id_cat_empresa integer);
       usuarios          vince    false    6            �           1255    25833 1   get_empresas(character varying, integer, integer)    FUNCTION     �  CREATE FUNCTION usuarios.get_empresas(str_empresa_nombre character varying, int_creado_por integer, int_actualizado_por integer) RETURNS TABLE(empresa_id_cat_empresa integer, empresa_nombre character varying, empresa_id_estado integer, empresa_fecha_creacion character varying, empresa_fecha_actualizacion character varying, empresa_nombre_creado_por character varying, empresa_id_creado_por integer, empresa_nombre_actualizado_por character varying, empresa_id_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select tce.id_cat_empresa as empresa_id_cat_empresa,
tce.nombre as empresa_nombre,
tce.estado as empresa_id_estado,
to_char(tce.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as empresa_fecha_creacion,
to_char(tce.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as empresa_fecha_actualizacion,
nombre_creado_por.nombre as empresa_nombre_creado_por,
tce.creado_por as empresa_id_creado_por,
nombre_actualizado_por.nombre as empresa_nombre_actualizado_por,
tce.actualizado_por as empresa_id_actualizado_por
from usuarios.tbl_cat_empresa tce 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tce.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tce.actualizado_por) nombre_actualizado_por ON true
where (tce.nombre LIKE ('%' || upper(str_empresa_nombre)  || '%')::varchar or LENGTH (upper(str_empresa_nombre)) = 0)
and (tce.creado_por = int_creado_por  or int_creado_por = 0)
and (tce.actualizado_por = int_actualizado_por  or int_actualizado_por = 0)
;
END;
$$;
 �   DROP FUNCTION usuarios.get_empresas(str_empresa_nombre character varying, int_creado_por integer, int_actualizado_por integer);
       usuarios          vince    false    6            �           1255    25878 (   get_equipo_responsable(integer, integer)    FUNCTION     a  CREATE FUNCTION usuarios.get_equipo_responsable(int_id_cat_usuario integer, int_cat_equipo integer) RETURNS TABLE(id integer, equipo_id integer, equipo_nombre character varying, equipo_estado integer, responable_id integer, responsable_nombre character varying, fecha_creacion character varying, fecha_actualizacion character varying, creado_por character varying, creado_por_id integer, actualizado_por character varying, actualizado_por_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select 
tdear.id_det_equipo_asignacion_responsable as id
,tce.id_cat_equipo as equipo_id
,tce.nombre as equipo_nombre
,tdear.estado as equipo_estado
,tdear.id_cat_usuario as responable_id
,nombre_usuario.nombre as responsable_nombre

,to_char(tdear.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion
,to_char(tdear.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion
,nombre_creado_por.nombre as creado_por
,tdear.creado_por  as creado_por_id
,nombre_actualizado_por.nombre as actualizado_por
,tdear.actualizado_por  as actualizado_por_id
from usuarios.tbl_det_equipo_asignacion_responsable tdear 
join usuarios.tbl_cat_equipo tce 
on tce.id_cat_equipo  = tdear.id_cat_equipo 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tdear.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tdear.actualizado_por ) nombre_actualizado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tdear.id_cat_usuario  ) nombre_usuario ON true
where (tdear.id_cat_usuario = int_id_cat_usuario  or int_id_cat_usuario = 0)
and (tce.id_cat_equipo = int_cat_equipo  or int_cat_equipo = 0)
;

END;
$$;
 c   DROP FUNCTION usuarios.get_equipo_responsable(int_id_cat_usuario integer, int_cat_equipo integer);
       usuarios          vince    false    6            �           1255    25879 $   get_equipo_usuario(integer, integer)    FUNCTION     K  CREATE FUNCTION usuarios.get_equipo_usuario(int_id_cat_usuario integer, int_cat_equipo integer) RETURNS TABLE(id integer, equipo_id integer, equipo_nombre character varying, equipo_estado integer, usuario_id integer, usuario_nombre character varying, fecha_creacion character varying, fecha_actualizacion character varying, creado_por character varying, creado_por_id integer, actualizado_por character varying, actualizado_por_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select  tduae.id_det_usuario_asignacion_equipo as id,
tce.id_cat_equipo  as equipo_id,
tce.nombre  as equipo_nombre,
tduae.estado as equipo_estado,
tduae.id_cat_usuario as usuario_id,
nombre_usuario.nombre as usuario_nombre

,to_char(tduae.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion
,to_char(tduae.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion

,nombre_creado_por.nombre as creado_por
,tduae.creado_por  as creado_por_id
,nombre_actualizado_por.nombre as actualizado_por
,tduae.actualizado_por  as actualizado_por_id
from usuarios.tbl_det_usuario_asignacion_equipo tduae 
join usuarios.tbl_cat_equipo tce on tce.id_cat_equipo  = tduae.id_cat_equipo 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tduae.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tduae.actualizado_por ) nombre_actualizado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tduae.id_cat_usuario  ) nombre_usuario ON true
where (tduae.id_cat_usuario = int_id_cat_usuario  or int_id_cat_usuario = 0)
and (tduae.id_cat_equipo  = int_cat_equipo  or int_cat_equipo = 0)
;

END;
$$;
 _   DROP FUNCTION usuarios.get_equipo_usuario(int_id_cat_usuario integer, int_cat_equipo integer);
       usuarios          vince    false    6            �           1255    25846 9   get_equipos(character varying, integer, integer, integer)    FUNCTION     �  CREATE FUNCTION usuarios.get_equipos(str_equipo_nombre character varying, int_id_cat_departamento integer, int_creado_por integer, int_actualizado_por integer) RETURNS TABLE(equipo_id_cat_equipo integer, equipo_nombre character varying, departamento_id_cat_departamento integer, departamento_nombre character varying, equipo_responsable_estado integer, equipo_responsable_fecha_creacion character varying, equipo_responsable_fecha_actualizacion character varying, equipo_responsable_creado_por character varying, equipo_responsable_id_creado_por integer, equipo_responsable_actualizado_por character varying, equipo_responsable_id_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select 
tce.id_cat_equipo as equipo_id_cat_equipo
,tce.nombre as equipo_nombre
,tcd.id_cat_departamento as departamento_id_cat_departamento
,tcd.nombre as departamento_nombre
,tce.estado as equipo_responsable_estado
,to_char(tce.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as equipo_responsable_fecha_creacion
,to_char(tce.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as equipo_responsable_fecha_actualizacion
,nombre_creado_por.nombre as equipo_responsable_creado_por
,tce.creado_por  as equipo_responsable_id_creado_por
,nombre_actualizado_por.nombre as equipo_responsable_actualizado_por
,tce.actualizado_por  as equipo_responsable_id_actualizado_por
from usuarios.tbl_cat_equipo tce 
join usuarios.tbl_cat_departamento tcd 
on tce.id_cat_departamento  =  tcd.id_cat_departamento 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tce.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tce.actualizado_por ) nombre_actualizado_por ON true
where (upper(tce.nombre) LIKE ('%' || upper(str_equipo_nombre)  || '%')::varchar or LENGTH (upper(str_equipo_nombre)) = 0)
and (tcd.id_cat_departamento = int_id_cat_departamento  or int_id_cat_departamento = 0)
and (tce.creado_por = int_creado_por  or int_creado_por = 0)
and (tce.actualizado_por = int_actualizado_por  or int_actualizado_por = 0)
;

END;
$$;
 �   DROP FUNCTION usuarios.get_equipos(str_equipo_nombre character varying, int_id_cat_departamento integer, int_creado_por integer, int_actualizado_por integer);
       usuarios          vince    false    6            �           1255    25829 0   get_puestos(character varying, integer, integer)    FUNCTION     c  CREATE FUNCTION usuarios.get_puestos(str_puesto_nombre character varying, int_creado_por integer, int_actualizado_por integer) RETURNS TABLE(id_cat_puesto integer, puesto_nombre character varying, puesto_estado integer, puesto_fecha_creacion character varying, puesto_fecha_actualizacion character varying, puesto_nombre_creado_por character varying, puesto_id_creado_por integer, puesto_nombre_actualizado_por character varying, puesto_id_actualizado_por integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
select 
tcp.id_cat_puesto,
tcp.nombre as puesto_nombre,
tcp.estado as puesto_estado,
to_char(tcp.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as puesto_fecha_creacion,
to_char(tcp.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as puesto_fecha_actualizacion,
nombre_creado_por.nombre as puesto_nombre_creado_por,
tcp.creado_por  as puesto_id_creado_por,
nombre_actualizado_por.nombre as puesto_nombre_actualizado_por,
tcp.actualizado_por as puesto_id_actualizado_por
from usuarios.tbl_cat_puesto tcp 
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tcp.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tcp.actualizado_por) nombre_actualizado_por ON true
where (tcp.nombre LIKE ('%' || upper(str_puesto_nombre)  || '%')::varchar or LENGTH (upper(str_puesto_nombre)) = 0)
and (tcp.creado_por = int_creado_por  or int_creado_por = 0)
and (tcp.actualizado_por = int_actualizado_por  or int_actualizado_por = 0)
;
END;
$$;
 ~   DROP FUNCTION usuarios.get_puestos(str_puesto_nombre character varying, int_creado_por integer, int_actualizado_por integer);
       usuarios          vince    false    6            �           1255    26979 �  get_ticket_all(character varying, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)    FUNCTION     W!  CREATE FUNCTION usuarios.get_ticket_all(string_nombre_referencia character varying, int_id_prioridad integer, int_estado_resolucion integer, int_id_proceso integer, int_id_cat_tipo integer, int_id_cat_canal integer, int_id_cat_equipo integer, int_id_cat_seguimiento integer, int_id_cat_responsable integer, int_id_cat_solicitante integer, int_id_cat_creado_por integer, date_asignacion_inicio character varying, date_asignacion_fin character varying, date_resolucion_inicio character varying, date_resolucion_fin character varying, date_ultima_vista_inicio character varying, date_ultima_vista_fin character varying, date_vencimiento_inicio character varying, date_vencimiento_fin character varying, date_primera_respuesta_inicio character varying, date_primera_respuesta_fin character varying, date_creacion_inicio character varying, date_creacion_fin character varying, date_actualizacion_inicio character varying, date_actualizacion_fin character varying) RETURNS TABLE(id_ticket integer, solicitante_nombre character varying, solicitante_id integer, equipo character varying, id_cat_equipo integer, id_responsable integer, usuario_responsable character varying, tipo_ticket character varying, id_cat_ticket_tipo integer, referencia character varying, referencia_ticket_padre character varying, canal character varying, id_cat_ticket_canal integer, resumen character varying, descripcion character varying, prioridad character varying, id_cat_ticket_prioridad integer, proceso character varying, id_cat_ticket_estado_proceso integer, estado_resolucion character varying, id_cat_ticket_estado_resolucion integer, nombre_proceso character varying, id_cat_proceso integer, fecha_asignacion character varying, fecha_resolucion character varying, fecha_ultima_vista character varying, fecha_vencimiento character varying, fecha_primera_respuesta character varying, creado_por integer, creado_nombre character varying, actualizado_por integer, actualizado_nombre character varying, id_cat_usuario integer, fecha_creacion character varying, fecha_actualizacion character varying, seguimiento character varying, id_bit_ticket_seguimiento integer)
    LANGUAGE plpgsql
    AS $$

BEGIN 
    RETURN QUERY
    SELECT tbt.id_bit_ticket AS id_ticket,
        tcu.nombre AS solicitante_nombre,
        tcu.id_cat_usuario AS solicitante_id,
        tce.nombre AS equipo,
        tce.id_cat_equipo AS id_cat_equipo,
        tbt.usuario_responsable AS id_responsable,
        responsable.nombre AS usuario_responsable,
        tctt.nombre AS tipo_ticket,
        tctt.id_cat_ticket_tipo,
        tbt.referencia,
        tbt.referencia_ticket_padre,
        tctc.nombre AS canal,
        tctc.id_cat_ticket_canal,
        tbt.resumen,
        tbt.descripcion,
        tctp.nombre AS prioridad,
        tctp.id_cat_ticket_prioridad,
        tctep.nombre AS proceso,
        tctep.id_cat_ticket_estado_proceso,
        tcter.nombre AS estado_resolucion,
        tcter.id_cat_ticket_estado_resolucion,
        tcp.nombre AS nombre_proceso,
        tcp.id_cat_proceso,
        to_char(tbt.fecha_asignacion, 'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_asignacion,
        to_char(tbt.fecha_resolucion, 'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_resolucion,
        to_char(tbt.fecha_ultima_vista,'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_ultima_vista,
        to_char(tbt.fecha_vencimiento, 'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_vencimiento,
        to_char(tbt.fecha_primera_respuesta,'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_primera_respuesta,
        tbt.creado_por,
        creado_por.nombre AS creado_nombre,
        tbt.actualizado_por,
        modificado_por.nombre AS actualizado_nombre,
        tcu.id_cat_usuario,
        to_char(tbt.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_creacion,
        to_char(tbt.fecha_actualizacion,'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_actualizacion,
        seguimiento.nombre AS seguimiento,
        tbts.id_bit_ticket_seguimiento

    FROM nova_ticket.tbl_bit_ticket tbt
        LEFT JOIN usuarios.tbl_cat_usuario tcu ON tcu.id_cat_usuario = tbt.usuario_solicitante
        LEFT JOIN usuarios.tbl_cat_equipo tce ON tce.id_cat_equipo = tbt.id_cat_equipo
        LEFT JOIN nova_ticket.tbl_cat_ticket_tipo tctt ON tctt.id_cat_ticket_tipo = tbt.id_cat_ticket_tipo
        LEFT JOIN nova_ticket.tbl_cat_ticket_canal tctc ON tctc.id_cat_ticket_canal = tbt.id_cat_ticket_canal
        LEFT JOIN nova_ticket.tbl_cat_ticket_prioridad tctp ON tctp.id_cat_ticket_prioridad = tbt.id_cat_ticket_prioridad
        LEFT JOIN nova_ticket.tbl_cat_ticket_estado_proceso tctep ON tctep.id_cat_ticket_estado_proceso = tbt.id_cat_ticket_estado_proceso
        LEFT JOIN nova_ticket.tbl_cat_ticket_estado_resolucion tcter ON tcter.id_cat_ticket_estado_resolucion = tbt.id_cat_ticket_estado_resolucion
        LEFT JOIN nova_proceso_tarea.tbl_cat_proceso tcp ON tcp.id_cat_proceso = tbt.id_cat_proceso
        LEFT JOIN nova_ticket.tbl_bit_ticket_seguimiento tbts ON tbts.id_bit_ticket = tbt.id_bit_ticket AND tbts.id_cat_usuario = tcu.id_cat_usuario
        LEFT JOIN LATERAL (SELECT tcu2.nombre AS nombre FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tbt.usuario_responsable) responsable ON true
        LEFT JOIN LATERAL (SELECT tcu3.nombre AS nombre FROM usuarios.tbl_cat_usuario tcu3 WHERE tcu3.id_cat_usuario = tbt.creado_por) creado_por ON true
        LEFT JOIN LATERAL (SELECT tcu4.nombre AS nombre FROM usuarios.tbl_cat_usuario tcu4 WHERE tcu4.id_cat_usuario = tbt.actualizado_por) modificado_por ON TRUE
        LEFT JOIN LATERAL (SELECT tcu5.nombre AS nombre FROM usuarios.tbl_cat_usuario tcu5 WHERE tcu5.id_cat_usuario = tbts.id_cat_usuario) seguimiento ON TRUE

    WHERE 
        ((UPPER(tbt.resumen) LIKE ('%' || UPPER(string_nombre_referencia) || '%')::VARCHAR) OR (UPPER(tbt.referencia) LIKE ('%' || UPPER(string_nombre_referencia) || '%')::VARCHAR) OR (LENGTH(string_nombre_referencia) = 0))
        AND (tctp.id_cat_ticket_prioridad = int_id_prioridad OR int_id_prioridad = 0)
        AND (tcter.id_cat_ticket_estado_resolucion = int_estado_resolucion OR int_estado_resolucion = 0)
        AND (tcp.id_cat_proceso = int_id_proceso OR int_id_proceso = 0)
        AND (tctt.id_cat_ticket_tipo = int_id_cat_tipo OR int_id_cat_tipo = 0)
        AND (tctc.id_cat_ticket_canal = int_id_cat_canal OR int_id_cat_canal = 0)
        AND (tce.id_cat_equipo = int_id_cat_equipo OR int_id_cat_equipo = 0)
        AND (tbts.id_bit_ticket_seguimiento = int_id_cat_seguimiento OR int_id_cat_seguimiento = 0)
        AND (tbt.usuario_responsable = int_id_cat_responsable OR int_id_cat_responsable = 0)
        AND (tbt.usuario_solicitante = int_id_cat_solicitante OR int_id_cat_solicitante = 0)
        AND ((to_char(tbt.fecha_asignacion, 'YYYY-MM-dd') >= date_asignacion_inicio AND to_char(tbt.fecha_asignacion, 'YYYY-MM-dd') <= date_asignacion_fin) OR (LENGTH(date_asignacion_inicio) = 0 AND LENGTH(date_asignacion_fin) = 0))
        AND ((to_char(tbt.fecha_resolucion, 'YYYY-MM-dd') >= date_resolucion_inicio AND to_char(tbt.fecha_resolucion, 'YYYY-MM-dd') <= date_resolucion_fin) OR (LENGTH(date_resolucion_inicio) = 0 AND LENGTH(date_resolucion_fin) = 0))
        AND ((to_char(tbt.fecha_ultima_vista, 'YYYY-MM-dd') >= date_ultima_vista_inicio AND to_char(tbt.fecha_ultima_vista, 'YYYY-MM-dd') <= date_ultima_vista_fin) OR (LENGTH(date_ultima_vista_inicio) = 0 AND LENGTH(date_ultima_vista_fin) = 0))
        AND ((to_char(tbt.fecha_vencimiento, 'YYYY-MM-dd') >= date_vencimiento_inicio AND to_char(tbt.fecha_vencimiento, 'YYYY-MM-dd') <= date_vencimiento_fin) OR (LENGTH(date_vencimiento_inicio) = 0 AND LENGTH(date_vencimiento_fin) = 0))
        AND ((to_char(tbt.fecha_primera_respuesta, 'YYYY-MM-dd') >= date_primera_respuesta_inicio AND to_char(tbt.fecha_primera_respuesta, 'YYYY-MM-dd') <= date_primera_respuesta_fin) OR (LENGTH(date_primera_respuesta_inicio) = 0 AND LENGTH(date_primera_respuesta_fin) = 0))
        AND ((to_char(tbt.fecha_creacion, 'YYYY-MM-dd') >= date_creacion_inicio AND to_char(tbt.fecha_creacion, 'YYYY-MM-dd') <= date_creacion_fin) OR (LENGTH(date_creacion_inicio) = 0 AND LENGTH(date_creacion_fin) = 0))
        AND ((to_char(tbt.fecha_actualizacion, 'YYYY-MM-dd') >= date_actualizacion_inicio AND to_char(tbt.fecha_actualizacion, 'YYYY-MM-dd') <= date_actualizacion_fin) OR (LENGTH(date_actualizacion_inicio) = 0 AND LENGTH(date_actualizacion_fin) = 0))
    
    ORDER BY
        tce.nombre ASC, tbt.referencia ASC, tbt.resumen ASC;
END;

$$;
 �  DROP FUNCTION usuarios.get_ticket_all(string_nombre_referencia character varying, int_id_prioridad integer, int_estado_resolucion integer, int_id_proceso integer, int_id_cat_tipo integer, int_id_cat_canal integer, int_id_cat_equipo integer, int_id_cat_seguimiento integer, int_id_cat_responsable integer, int_id_cat_solicitante integer, int_id_cat_creado_por integer, date_asignacion_inicio character varying, date_asignacion_fin character varying, date_resolucion_inicio character varying, date_resolucion_fin character varying, date_ultima_vista_inicio character varying, date_ultima_vista_fin character varying, date_vencimiento_inicio character varying, date_vencimiento_fin character varying, date_primera_respuesta_inicio character varying, date_primera_respuesta_fin character varying, date_creacion_inicio character varying, date_creacion_fin character varying, date_actualizacion_inicio character varying, date_actualizacion_fin character varying);
       usuarios          vince    false    6            �           1255    26593 %   get_usuario_puestos(integer, integer)    FUNCTION     �
  CREATE FUNCTION usuarios.get_usuario_puestos(int_id_cat_usuario integer, int_predeterminado integer) RETURNS TABLE(id integer, empresa_id integer, empresa_nombre character varying, departamento_id integer, departamento_nombre character varying, equipo_id integer, equipo_nombre character varying, nombre character varying, puesto_id integer, responsable_id integer, responsable character varying, predeterminado integer, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por character varying, creado_por_id integer, actualizado_por character varying, actualizado_por_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  
  select 
tddar.id_det_usuario_asignacion_puesto as id
,tcd.id_cat_empresa as empresa_id
,tcee.nombre as empresa_nombre
,tce.id_cat_departamento as departamento_id
,tcd.nombre as departamento_nombre
,tduap.id_cat_equipo as equipo_id
,tce.nombre as equipo_nombre
,tdear.nombre as nombre
,tdear.id_cat_puesto  as puesto_id
,tddar.id_cat_usuario  as responsable_id
,nombre_usuario.nombre as responsable
,tddar.predeterminado as predeterminado
,tddar.estado as estado
,to_char(tddar.fecha_creacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar as fecha_creacion
,to_char(tddar.fecha_actualizacion, 'YYYY-MM-DD HH:MI:SS AM')::varchar  as fecha_actualizacion
,nombre_creado_por.nombre as creado_por
,tddar.creado_por  as creado_por_id
,nombre_actualizado_por.nombre as actualizado_por
,tddar.actualizado_por  as actualizado_por_id
from usuarios.tbl_det_usuario_asignacion_puesto tddar 
left join usuarios.tbl_det_puesto_asignacion_equipo tduap 
on tduap.id_det_puesto_asignacion_equipo  = tddar.id_det_puesto_asignacion_equipo  
left join usuarios.tbl_cat_puesto tdear 
on tdear.id_cat_puesto  = tduap.id_cat_puesto 
join usuarios.tbl_cat_equipo tce 
on tce.id_cat_equipo  = tduap.id_cat_equipo 
join usuarios.tbl_cat_departamento tcd 
on tcd.id_cat_departamento  = tce.id_cat_departamento 
join usuarios.tbl_cat_empresa tcee 
on tcee.id_cat_empresa  = tcd.id_cat_empresa
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tddar.creado_por) nombre_creado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tddar.actualizado_por ) nombre_actualizado_por ON true
LEFT JOIN LATERAL (SELECT tcu2.nombre as nombre  FROM usuarios.tbl_cat_usuario tcu2 WHERE tcu2.id_cat_usuario = tddar.id_cat_usuario  ) nombre_usuario ON true
where
(tddar.id_cat_usuario   = int_id_cat_usuario  or int_id_cat_usuario = 0 )
and (tddar.predeterminado   = int_predeterminado  or int_predeterminado = 0 )
;

END;
$$;
 d   DROP FUNCTION usuarios.get_usuario_puestos(int_id_cat_usuario integer, int_predeterminado integer);
       usuarios          vince    false    6            �           1255    26978 D   get_usuarios(character varying, integer, integer, character varying)    FUNCTION     ;  CREATE FUNCTION usuarios.get_usuarios(str_usuario_nombre character varying, int_creado_por integer, int_actualizado_por integer, str_username character varying) RETURNS TABLE(id_cat_usuario integer, nombre character varying, id_ad character varying, correo character varying, user_principal_name character varying, telefono character varying, codigo_pais integer, tipo_pais integer, dominio_nombre character varying, dominio_id integer, categoria_nombre character varying, categoria_id integer, estado integer, fecha_creacion character varying, fecha_actualizacion character varying, creado_por_nombre character varying, creado_por_id integer, actualizado_por_nombre character varying, actualizado_por_id integer, username character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN 
  RETURN QUERY

  SELECT T_USUARIO.id_cat_usuario AS id_cat_usuario,
    T_USUARIO.nombre AS nombre,
    T_USUARIO.id_ad AS id_ad,
    T_USUARIO.correo AS correo,
    T_USUARIO.user_principal_name AS user_principal_name,
    T_USUARIO.telefono::VARCHAR AS telefono,
    T_USUARIO.codigo_pais AS codigo_pais,
    T_USUARIO.tipo_usuario AS tipo_pais,
    T_DOMINIO.nombre AS dominio_nombre,
    T_USUARIO.id_cat_usuario_dominio AS dominio_id,
    T_US_CATEGORIA.nombre AS categoria_nombre,
    T_US_CATEGORIA.id_cat_usuario_categoria AS categoria_id,
    T_USUARIO.estado AS estado,
    to_char(T_USUARIO.fecha_creacion,'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_creacion,
    to_char(T_USUARIO.fecha_actualizacion,'YYYY-MM-DD HH:MI:SS AM')::VARCHAR AS fecha_actualizacion,
    T_CREADO.nombre AS creado_por_nombre,
    T_USUARIO.creado_por AS creado_por_id,
    T_ACTUALIZADO.nombre AS actualizado_por_nombre,
    T_USUARIO.actualizado_por AS actualizado_por_id,
    T_USUARIO.username AS username
  
  FROM usuarios.tbl_cat_usuario T_USUARIO
    LEFT JOIN usuarios.tbl_cat_usuario_dominio T_DOMINIO ON T_USUARIO.id_cat_usuario_dominio = T_DOMINIO.id_cat_usuario_dominio
    LEFT JOIN usuarios.tbl_cat_usuario_categoria T_US_CATEGORIA ON T_US_CATEGORIA.id_cat_usuario_categoria = T_USUARIO.id_cat_usuario_categoria
    LEFT JOIN LATERAL (SELECT T_USUARIO2.nombre AS nombre FROM usuarios.tbl_cat_usuario T_USUARIO2 WHERE T_USUARIO2.id_cat_usuario = T_USUARIO.creado_por) T_CREADO ON true
    LEFT JOIN LATERAL (SELECT T_USUARIO2.nombre AS nombre FROM usuarios.tbl_cat_usuario T_USUARIO2 WHERE T_USUARIO2.id_cat_usuario = T_USUARIO.actualizado_por) T_ACTUALIZADO ON true
  
  WHERE 
    (UPPER(T_USUARIO.nombre) LIKE ('%' || UPPER(str_usuario_nombre) || '%')::VARCHAR OR LENGTH (UPPER(str_usuario_nombre)) = 0)
    AND (T_USUARIO.creado_por = int_creado_por OR int_creado_por = 0)
    AND (T_USUARIO.actualizado_por = int_actualizado_por OR int_actualizado_por = 0)
    AND (UPPER(T_USUARIO.username) LIKE ('%' || UPPER(str_username) || '%')::VARCHAR OR LENGTH (UPPER(str_username)) = 0);
END
$$;
 �   DROP FUNCTION usuarios.get_usuarios(str_usuario_nombre character varying, int_creado_por integer, int_actualizado_por integer, str_username character varying);
       usuarios          vince    false    6            ~           1259    26382    tbl_cat_cuenta    TABLE     �  CREATE TABLE compras_cuenta.tbl_cat_cuenta (
    id_cat_cuenta integer NOT NULL,
    id_cat_cuenta_clasificacion integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(600),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:59:27.926981'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 *   DROP TABLE compras_cuenta.tbl_cat_cuenta;
       compras_cuenta         heap    vince    false    21            r           1259    26149    tbl_cat_cuenta_clasificacion    TABLE     �  CREATE TABLE compras_cuenta.tbl_cat_cuenta_clasificacion (
    id_cat_cuenta_clasificacion integer NOT NULL,
    nombre character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:59:15.509724'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 8   DROP TABLE compras_cuenta.tbl_cat_cuenta_clasificacion;
       compras_cuenta         heap    vince    false    21            q           1259    26148 <   tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq    SEQUENCE     �   CREATE SEQUENCE compras_cuenta.tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 [   DROP SEQUENCE compras_cuenta.tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq;
       compras_cuenta          vince    false    21    370            �           0    0 <   tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_cuenta.tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq OWNED BY compras_cuenta.tbl_cat_cuenta_clasificacion.id_cat_cuenta_clasificacion;
          compras_cuenta          vince    false    369            }           1259    26381     tbl_cat_cuenta_id_cat_cuenta_seq    SEQUENCE     �   CREATE SEQUENCE compras_cuenta.tbl_cat_cuenta_id_cat_cuenta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE compras_cuenta.tbl_cat_cuenta_id_cat_cuenta_seq;
       compras_cuenta          vince    false    382    21            �           0    0     tbl_cat_cuenta_id_cat_cuenta_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE compras_cuenta.tbl_cat_cuenta_id_cat_cuenta_seq OWNED BY compras_cuenta.tbl_cat_cuenta.id_cat_cuenta;
          compras_cuenta          vince    false    381            f           1259    26094    tbl_cat_cuenta_bancaria    TABLE     �  CREATE TABLE compras_cuenta_bancaria.tbl_cat_cuenta_bancaria (
    id_cat_cuenta_bancaria integer NOT NULL,
    id_cat_empresa integer NOT NULL,
    nombre character varying(255),
    nit character varying(15),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:58:01.028165'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 <   DROP TABLE compras_cuenta_bancaria.tbl_cat_cuenta_bancaria;
       compras_cuenta_bancaria         heap    vince    false    19            e           1259    26093 2   tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq    SEQUENCE     �   CREATE SEQUENCE compras_cuenta_bancaria.tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 Z   DROP SEQUENCE compras_cuenta_bancaria.tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq;
       compras_cuenta_bancaria          vince    false    19    358            �           0    0 2   tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_cuenta_bancaria.tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq OWNED BY compras_cuenta_bancaria.tbl_cat_cuenta_bancaria.id_cat_cuenta_bancaria;
          compras_cuenta_bancaria          vince    false    357            `           1259    26068    tbl_cat_moneda    TABLE     �  CREATE TABLE compras_orden_compra.tbl_cat_moneda (
    id_cat_moneda integer NOT NULL,
    abreviatura character varying(5),
    monto_compra character varying(45),
    monto_venta numeric,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:57:06.139502'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 0   DROP TABLE compras_orden_compra.tbl_cat_moneda;
       compras_orden_compra         heap    vince    false    18            _           1259    26067     tbl_cat_moneda_id_cat_moneda_seq    SEQUENCE     �   CREATE SEQUENCE compras_orden_compra.tbl_cat_moneda_id_cat_moneda_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE compras_orden_compra.tbl_cat_moneda_id_cat_moneda_seq;
       compras_orden_compra          vince    false    352    18            �           0    0     tbl_cat_moneda_id_cat_moneda_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_orden_compra.tbl_cat_moneda_id_cat_moneda_seq OWNED BY compras_orden_compra.tbl_cat_moneda.id_cat_moneda;
          compras_orden_compra          vince    false    351            n           1259    26131    tbl_cat_orden_compra    TABLE     �  CREATE TABLE compras_orden_compra.tbl_cat_orden_compra (
    id_cat_orden_compra integer NOT NULL,
    id_cat_orden_compra_metodo_pago integer NOT NULL,
    id_cat_orden_compra_tipo_cuota integer NOT NULL,
    id_cat_moneda integer NOT NULL,
    solicitante integer NOT NULL,
    aprobador_presupuesto integer NOT NULL,
    aprobador_tesoreria integer NOT NULL,
    aprobador_extraordinario integer,
    id_cat_proveedor integer NOT NULL,
    numero_correlativo character varying(45),
    cuotas integer,
    monto_cuotas numeric,
    mes character varying(45),
    id_cat_presupuesto integer NOT NULL,
    tamano_odc character varying(45),
    estado_ppt character varying(45),
    total_gastado numeric,
    comentario character varying(45),
    fecha_aprobacion_tesoreria timestamp without time zone,
    fecha_aprobacion_presupuesto timestamp without time zone,
    fecha_aprobacion_extraordinario timestamp without time zone,
    id_cat_orden_compra_estado integer NOT NULL,
    id_cat_cuenta_bancaria integer NOT NULL,
    dentro_presupuesto boolean,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:58:50.89413'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 6   DROP TABLE compras_orden_compra.tbl_cat_orden_compra;
       compras_orden_compra         heap    vince    false    18            h           1259    26102    tbl_cat_orden_compra_estado    TABLE     �  CREATE TABLE compras_orden_compra.tbl_cat_orden_compra_estado (
    id_cat_orden_compra_estado integer NOT NULL,
    nombre character varying(50),
    descripcion character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:58:11.948572'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 =   DROP TABLE compras_orden_compra.tbl_cat_orden_compra_estado;
       compras_orden_compra         heap    vince    false    18            g           1259    26101 :   tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq    SEQUENCE     �   CREATE SEQUENCE compras_orden_compra.tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 _   DROP SEQUENCE compras_orden_compra.tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq;
       compras_orden_compra          vince    false    360    18            �           0    0 :   tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_orden_compra.tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq OWNED BY compras_orden_compra.tbl_cat_orden_compra_estado.id_cat_orden_compra_estado;
          compras_orden_compra          vince    false    359            m           1259    26130 ,   tbl_cat_orden_compra_id_cat_orden_compra_seq    SEQUENCE     �   CREATE SEQUENCE compras_orden_compra.tbl_cat_orden_compra_id_cat_orden_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 Q   DROP SEQUENCE compras_orden_compra.tbl_cat_orden_compra_id_cat_orden_compra_seq;
       compras_orden_compra          vince    false    18    366            �           0    0 ,   tbl_cat_orden_compra_id_cat_orden_compra_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_orden_compra.tbl_cat_orden_compra_id_cat_orden_compra_seq OWNED BY compras_orden_compra.tbl_cat_orden_compra.id_cat_orden_compra;
          compras_orden_compra          vince    false    365            d           1259    26086     tbl_cat_orden_compra_metodo_pago    TABLE     �  CREATE TABLE compras_orden_compra.tbl_cat_orden_compra_metodo_pago (
    id_cat_orden_compra_metodo_pago integer NOT NULL,
    nombre character varying(50),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:57:44.156443'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 B   DROP TABLE compras_orden_compra.tbl_cat_orden_compra_metodo_pago;
       compras_orden_compra         heap    vince    false    18            c           1259    26085 ?   tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq    SEQUENCE     �   CREATE SEQUENCE compras_orden_compra.tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 d   DROP SEQUENCE compras_orden_compra.tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq;
       compras_orden_compra          vince    false    18    356            �           0    0 ?   tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_orden_compra.tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq OWNED BY compras_orden_compra.tbl_cat_orden_compra_metodo_pago.id_cat_orden_compra_metodo_pago;
          compras_orden_compra          vince    false    355            b           1259    26078    tbl_cat_orden_compra_tipo_cuota    TABLE     �  CREATE TABLE compras_orden_compra.tbl_cat_orden_compra_tipo_cuota (
    id_cat_orden_compra_tipo_cuota integer NOT NULL,
    nombre character varying(50),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:57:15.268108'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 A   DROP TABLE compras_orden_compra.tbl_cat_orden_compra_tipo_cuota;
       compras_orden_compra         heap    vince    false    18            a           1259    26077 ?   tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq    SEQUENCE     �   CREATE SEQUENCE compras_orden_compra.tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 d   DROP SEQUENCE compras_orden_compra.tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq;
       compras_orden_compra          vince    false    18    354            �           0    0 ?   tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_orden_compra.tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq OWNED BY compras_orden_compra.tbl_cat_orden_compra_tipo_cuota.id_cat_orden_compra_tipo_cuota;
          compras_orden_compra          vince    false    353            p           1259    26141    tbl_det_orden_compra    TABLE     �  CREATE TABLE compras_orden_compra.tbl_det_orden_compra (
    id_det_orden_compra integer NOT NULL,
    id_cat_orden_compra integer NOT NULL,
    producto character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:59:07.469551'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 6   DROP TABLE compras_orden_compra.tbl_det_orden_compra;
       compras_orden_compra         heap    vince    false    18            o           1259    26140 ,   tbl_det_orden_compra_id_det_orden_compra_seq    SEQUENCE     �   CREATE SEQUENCE compras_orden_compra.tbl_det_orden_compra_id_det_orden_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 Q   DROP SEQUENCE compras_orden_compra.tbl_det_orden_compra_id_det_orden_compra_seq;
       compras_orden_compra          vince    false    18    368            �           0    0 ,   tbl_det_orden_compra_id_det_orden_compra_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_orden_compra.tbl_det_orden_compra_id_det_orden_compra_seq OWNED BY compras_orden_compra.tbl_det_orden_compra.id_det_orden_compra;
          compras_orden_compra          vince    false    367            |           1259    26208    tbl_bit_presupuesto_ajuste    TABLE     +  CREATE TABLE compras_presupuesto.tbl_bit_presupuesto_ajuste (
    id_bit_presupuesto_ajuste integer NOT NULL,
    id_det_presupuesto integer NOT NULL,
    mes character varying(45),
    cuenta_abono integer NOT NULL,
    cuenta_cargo integer NOT NULL,
    monto numeric,
    justificacion character varying(600),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 09:01:33.329794'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 ;   DROP TABLE compras_presupuesto.tbl_bit_presupuesto_ajuste;
       compras_presupuesto         heap    vince    false    20            {           1259    26207 8   tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq    SEQUENCE     �   CREATE SEQUENCE compras_presupuesto.tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 \   DROP SEQUENCE compras_presupuesto.tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq;
       compras_presupuesto          vince    false    20    380            �           0    0 8   tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_presupuesto.tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq OWNED BY compras_presupuesto.tbl_bit_presupuesto_ajuste.id_bit_presupuesto_ajuste;
          compras_presupuesto          vince    false    379            l           1259    26121    tbl_cat_presupuesto    TABLE     �  CREATE TABLE compras_presupuesto.tbl_cat_presupuesto (
    id_cat_presupuesto integer NOT NULL,
    id_cat_empresa integer NOT NULL,
    monto numeric,
    "año" integer,
    usuario_responsable integer NOT NULL,
    id_cat_presupuesto_estado integer NOT NULL,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:58:34.332767'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 4   DROP TABLE compras_presupuesto.tbl_cat_presupuesto;
       compras_presupuesto         heap    vince    false    20            j           1259    26111    tbl_cat_presupuesto_estado    TABLE     �  CREATE TABLE compras_presupuesto.tbl_cat_presupuesto_estado (
    id_cat_presupuesto_estado integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(600),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:58:21.916238'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 ;   DROP TABLE compras_presupuesto.tbl_cat_presupuesto_estado;
       compras_presupuesto         heap    vince    false    20            i           1259    26110 8   tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq    SEQUENCE     �   CREATE SEQUENCE compras_presupuesto.tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 \   DROP SEQUENCE compras_presupuesto.tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq;
       compras_presupuesto          vince    false    362    20            �           0    0 8   tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_presupuesto.tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq OWNED BY compras_presupuesto.tbl_cat_presupuesto_estado.id_cat_presupuesto_estado;
          compras_presupuesto          vince    false    361            k           1259    26120 *   tbl_cat_presupuesto_id_cat_presupuesto_seq    SEQUENCE     �   CREATE SEQUENCE compras_presupuesto.tbl_cat_presupuesto_id_cat_presupuesto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 N   DROP SEQUENCE compras_presupuesto.tbl_cat_presupuesto_id_cat_presupuesto_seq;
       compras_presupuesto          vince    false    20    364            �           0    0 *   tbl_cat_presupuesto_id_cat_presupuesto_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_presupuesto.tbl_cat_presupuesto_id_cat_presupuesto_seq OWNED BY compras_presupuesto.tbl_cat_presupuesto.id_cat_presupuesto;
          compras_presupuesto          vince    false    363            t           1259    26168    tbl_det_presupuesto    TABLE     e  CREATE TABLE compras_presupuesto.tbl_det_presupuesto (
    id_det_presupuesto integer NOT NULL,
    id_cat_presupuesto integer NOT NULL,
    id_cat_cuenta integer NOT NULL,
    monto_inicial numeric,
    enero_inicial numeric,
    enero_final numeric,
    febrero_inicial numeric,
    febrero_final numeric,
    marzo_inicial numeric,
    marzo_final numeric,
    abril_inicial numeric,
    abril_final numeric,
    mayo_inicial numeric,
    mayo_final numeric,
    junio_inicial numeric,
    junio_final numeric,
    julio_inicial numeric,
    julio_final numeric,
    agosto_inicial numeric,
    agosto_final numeric,
    septiembre_inicial numeric,
    septiembre_final numeric,
    octubre_inicial numeric,
    octubre_final numeric,
    noviembre_inicial numeric,
    noviembre_final numeric,
    diciembre_inicial numeric,
    diciembre_final numeric,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 09:00:32.304078'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer,
    monto_final numeric
);
 4   DROP TABLE compras_presupuesto.tbl_det_presupuesto;
       compras_presupuesto         heap    vince    false    20            s           1259    26167 *   tbl_det_presupuesto_id_det_presupuesto_seq    SEQUENCE     �   CREATE SEQUENCE compras_presupuesto.tbl_det_presupuesto_id_det_presupuesto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 N   DROP SEQUENCE compras_presupuesto.tbl_det_presupuesto_id_det_presupuesto_seq;
       compras_presupuesto          vince    false    372    20            �           0    0 *   tbl_det_presupuesto_id_det_presupuesto_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_presupuesto.tbl_det_presupuesto_id_det_presupuesto_seq OWNED BY compras_presupuesto.tbl_det_presupuesto.id_det_presupuesto;
          compras_presupuesto          vince    false    371            X           1259    26033    tbl_cat_producto    TABLE     �  CREATE TABLE compras_producto.tbl_cat_producto (
    id_cat_producto integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    id_cat_producto_categoria integer NOT NULL,
    id_cat_producto_unidad_medida integer NOT NULL,
    id_cat_proveedor integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(450),
    precio_compra numeric,
    precio_venta numeric,
    cantidad numeric,
    cantidad_minima integer,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:56:24.114181'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 .   DROP TABLE compras_producto.tbl_cat_producto;
       compras_producto         heap    vince    false    16            U           1259    26018    tbl_cat_producto_categoria    TABLE     �  CREATE TABLE compras_producto.tbl_cat_producto_categoria (
    id_cat_producto_categoria integer NOT NULL,
    nombre character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:56:03.025712'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 8   DROP TABLE compras_producto.tbl_cat_producto_categoria;
       compras_producto         heap    vince    false    16            T           1259    26017 8   tbl_cat_producto_categoria_id_cat_producto_categoria_seq    SEQUENCE     �   CREATE SEQUENCE compras_producto.tbl_cat_producto_categoria_id_cat_producto_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 Y   DROP SEQUENCE compras_producto.tbl_cat_producto_categoria_id_cat_producto_categoria_seq;
       compras_producto          vince    false    341    16            �           0    0 8   tbl_cat_producto_categoria_id_cat_producto_categoria_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_producto.tbl_cat_producto_categoria_id_cat_producto_categoria_seq OWNED BY compras_producto.tbl_cat_producto_categoria.id_cat_producto_categoria;
          compras_producto          vince    false    340            W           1259    26026    tbl_cat_producto_unidad_medida    TABLE     �  CREATE TABLE compras_producto.tbl_cat_producto_unidad_medida (
    id_cat_producto_unidad_medida integer NOT NULL,
    nombre character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:56:13.259225'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 <   DROP TABLE compras_producto.tbl_cat_producto_unidad_medida;
       compras_producto         heap    vince    false    16            V           1259    26025 ?   tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq    SEQUENCE     �   CREATE SEQUENCE compras_producto.tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 `   DROP SEQUENCE compras_producto.tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq;
       compras_producto          vince    false    343    16            �           0    0 ?   tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_producto.tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq OWNED BY compras_producto.tbl_cat_producto_unidad_medida.id_cat_producto_unidad_medida;
          compras_producto          vince    false    342            S           1259    26008    tbl_cat_proveedor    TABLE     �  CREATE TABLE compras_proveedor.tbl_cat_proveedor (
    id_cat_proveedor integer NOT NULL,
    id_cat_proveedor_giro integer NOT NULL,
    nombre_completo character varying(200),
    nit character varying(20),
    email character varying(200),
    telefono_contacto integer,
    celular_personal integer,
    rtu_archivo character varying(400),
    id_cat_proveedor_tipo integer NOT NULL,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:55:49.714058'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer,
    id_cat_usuario integer
);
 0   DROP TABLE compras_proveedor.tbl_cat_proveedor;
       compras_proveedor         heap    vince    false    15            O           1259    25990    tbl_cat_proveedor_giro    TABLE     �  CREATE TABLE compras_proveedor.tbl_cat_proveedor_giro (
    id_cat_proveedor_giro integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:53:30.149808'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 5   DROP TABLE compras_proveedor.tbl_cat_proveedor_giro;
       compras_proveedor         heap    vince    false    15            N           1259    25989 0   tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq    SEQUENCE     �   CREATE SEQUENCE compras_proveedor.tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 R   DROP SEQUENCE compras_proveedor.tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq;
       compras_proveedor          vince    false    335    15            �           0    0 0   tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_proveedor.tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq OWNED BY compras_proveedor.tbl_cat_proveedor_giro.id_cat_proveedor_giro;
          compras_proveedor          vince    false    334            R           1259    26007 &   tbl_cat_proveedor_id_cat_proveedor_seq    SEQUENCE     �   CREATE SEQUENCE compras_proveedor.tbl_cat_proveedor_id_cat_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE compras_proveedor.tbl_cat_proveedor_id_cat_proveedor_seq;
       compras_proveedor          vince    false    339    15            �           0    0 &   tbl_cat_proveedor_id_cat_proveedor_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_proveedor.tbl_cat_proveedor_id_cat_proveedor_seq OWNED BY compras_proveedor.tbl_cat_proveedor.id_cat_proveedor;
          compras_proveedor          vince    false    338            Q           1259    26000    tbl_cat_proveedor_tipo    TABLE     y  CREATE TABLE compras_proveedor.tbl_cat_proveedor_tipo (
    id_cat_proveedor_tipo integer NOT NULL,
    nombre character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:55:32.241666'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 5   DROP TABLE compras_proveedor.tbl_cat_proveedor_tipo;
       compras_proveedor         heap    vince    false    15            P           1259    25999 0   tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq    SEQUENCE     �   CREATE SEQUENCE compras_proveedor.tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 R   DROP SEQUENCE compras_proveedor.tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq;
       compras_proveedor          vince    false    15    337            �           0    0 0   tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_proveedor.tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq OWNED BY compras_proveedor.tbl_cat_proveedor_tipo.id_cat_proveedor_tipo;
          compras_proveedor          vince    false    336            x           1259    26188    tbl_cat_recepcion    TABLE     �  CREATE TABLE compras_recepcion.tbl_cat_recepcion (
    id_cat_recepcion integer NOT NULL,
    id_cat_orden_compra integer NOT NULL,
    id_cat_recepcion_estado integer NOT NULL,
    comentario character varying(255),
    entregado_por integer NOT NULL,
    recibido_por integer NOT NULL,
    entregado_por_firma character varying(600),
    recibido_por_firma character varying(600),
    fecha_recepcion timestamp without time zone,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 09:00:58.753257'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 0   DROP TABLE compras_recepcion.tbl_cat_recepcion;
       compras_recepcion         heap    vince    false    22            v           1259    26178    tbl_cat_recepcion_estado    TABLE     �  CREATE TABLE compras_recepcion.tbl_cat_recepcion_estado (
    id_cat_recepcion_estado integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 09:00:41.368358'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 7   DROP TABLE compras_recepcion.tbl_cat_recepcion_estado;
       compras_recepcion         heap    vince    false    22            u           1259    26177 4   tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq    SEQUENCE     �   CREATE SEQUENCE compras_recepcion.tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 V   DROP SEQUENCE compras_recepcion.tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq;
       compras_recepcion          vince    false    22    374            �           0    0 4   tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_recepcion.tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq OWNED BY compras_recepcion.tbl_cat_recepcion_estado.id_cat_recepcion_estado;
          compras_recepcion          vince    false    373            w           1259    26187 &   tbl_cat_recepcion_id_cat_recepcion_seq    SEQUENCE     �   CREATE SEQUENCE compras_recepcion.tbl_cat_recepcion_id_cat_recepcion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE compras_recepcion.tbl_cat_recepcion_id_cat_recepcion_seq;
       compras_recepcion          vince    false    22    376            �           0    0 &   tbl_cat_recepcion_id_cat_recepcion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_recepcion.tbl_cat_recepcion_id_cat_recepcion_seq OWNED BY compras_recepcion.tbl_cat_recepcion.id_cat_recepcion;
          compras_recepcion          vince    false    375            z           1259    26198    tbl_det_recepcion    TABLE     >  CREATE TABLE compras_recepcion.tbl_det_recepcion (
    id_det_recepcion integer NOT NULL,
    id_cat_recepcion integer NOT NULL,
    id_cat_producto integer NOT NULL,
    producto character varying(255),
    cantidad_solicitada integer,
    cantidad_recibida integer,
    diferencia integer,
    observacion character varying(255),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 09:01:12.024796'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 0   DROP TABLE compras_recepcion.tbl_det_recepcion;
       compras_recepcion         heap    vince    false    22            y           1259    26197 &   tbl_det_recepcion_id_det_recepcion_seq    SEQUENCE     �   CREATE SEQUENCE compras_recepcion.tbl_det_recepcion_id_det_recepcion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE compras_recepcion.tbl_det_recepcion_id_det_recepcion_seq;
       compras_recepcion          vince    false    22    378            �           0    0 &   tbl_det_recepcion_id_det_recepcion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_recepcion.tbl_det_recepcion_id_det_recepcion_seq OWNED BY compras_recepcion.tbl_det_recepcion.id_det_recepcion;
          compras_recepcion          vince    false    377            \           1259    26050    tbl_cat_solicitud    TABLE     
  CREATE TABLE compras_solicitud.tbl_cat_solicitud (
    id_cat_solicitud integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    total numeric,
    comentario character varying(450),
    fecha_solicitud timestamp without time zone,
    id_cat_solicitud_estado integer NOT NULL,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:56:47.170843'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 0   DROP TABLE compras_solicitud.tbl_cat_solicitud;
       compras_solicitud         heap    vince    false    17            Z           1259    26040    tbl_cat_solicitud_estado    TABLE     �  CREATE TABLE compras_solicitud.tbl_cat_solicitud_estado (
    id_cat_solicitud_estado integer NOT NULL,
    nombre character varying(45),
    descripcion character varying(450),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:56:36.546922'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 7   DROP TABLE compras_solicitud.tbl_cat_solicitud_estado;
       compras_solicitud         heap    vince    false    17            Y           1259    26039 4   tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq    SEQUENCE     �   CREATE SEQUENCE compras_solicitud.tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 V   DROP SEQUENCE compras_solicitud.tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq;
       compras_solicitud          vince    false    17    346            �           0    0 4   tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_solicitud.tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq OWNED BY compras_solicitud.tbl_cat_solicitud_estado.id_cat_solicitud_estado;
          compras_solicitud          vince    false    345            [           1259    26049 &   tbl_cat_solicitud_id_cat_solicitud_seq    SEQUENCE     �   CREATE SEQUENCE compras_solicitud.tbl_cat_solicitud_id_cat_solicitud_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE compras_solicitud.tbl_cat_solicitud_id_cat_solicitud_seq;
       compras_solicitud          vince    false    17    348            �           0    0 &   tbl_cat_solicitud_id_cat_solicitud_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_solicitud.tbl_cat_solicitud_id_cat_solicitud_seq OWNED BY compras_solicitud.tbl_cat_solicitud.id_cat_solicitud;
          compras_solicitud          vince    false    347            ^           1259    26060    tbl_det_solicitud    TABLE     �  CREATE TABLE compras_solicitud.tbl_det_solicitud (
    id_det_solicitud integer NOT NULL,
    id_cat_solicitud integer NOT NULL,
    id_cat_producto integer NOT NULL,
    cantidad integer,
    comentario character varying(450),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-01-30 08:56:56.002916'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 0   DROP TABLE compras_solicitud.tbl_det_solicitud;
       compras_solicitud         heap    vince    false    17            ]           1259    26059 &   tbl_det_solicitud_id_det_solicitud_seq    SEQUENCE     �   CREATE SEQUENCE compras_solicitud.tbl_det_solicitud_id_det_solicitud_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE compras_solicitud.tbl_det_solicitud_id_det_solicitud_seq;
       compras_solicitud          vince    false    350    17            �           0    0 &   tbl_det_solicitud_id_det_solicitud_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE compras_solicitud.tbl_det_solicitud_id_det_solicitud_seq OWNED BY compras_solicitud.tbl_det_solicitud.id_det_solicitud;
          compras_solicitud          vince    false    349            �           1259    26962    tbl_bit_marcaje    TABLE     �   CREATE TABLE general.tbl_bit_marcaje (
    id_bit_marcaje integer NOT NULL,
    usuario character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    accion character varying
);
 $   DROP TABLE general.tbl_bit_marcaje;
       general         heap    vince    false    13            �           1259    26969 "   tbl_bit_marcaje_id_bit_marcaje_seq    SEQUENCE     �   CREATE SEQUENCE general.tbl_bit_marcaje_id_bit_marcaje_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 :   DROP SEQUENCE general.tbl_bit_marcaje_id_bit_marcaje_seq;
       general          vince    false    13    392            �           0    0 "   tbl_bit_marcaje_id_bit_marcaje_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE general.tbl_bit_marcaje_id_bit_marcaje_seq OWNED BY general.tbl_bit_marcaje.id_bit_marcaje;
          general          vince    false    393            '           1259    24592    tbl_bit_reporte_consulta    TABLE     �   CREATE TABLE general.tbl_bit_reporte_consulta (
    id_bit_reporte_consulta integer NOT NULL,
    usuario character varying(50),
    reporte character varying(255),
    fecha_hora timestamp without time zone DEFAULT now(),
    consulta json
);
 -   DROP TABLE general.tbl_bit_reporte_consulta;
       general         heap    vince    false    13            &           1259    24591 4   tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq    SEQUENCE     �   CREATE SEQUENCE general.tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 L   DROP SEQUENCE general.tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq;
       general          vince    false    13    295            �           0    0 4   tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE general.tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq OWNED BY general.tbl_bit_reporte_consulta.id_bit_reporte_consulta;
          general          vince    false    294            /           1259    24765    tbl_cat_mes    TABLE     �   CREATE TABLE general.tbl_cat_mes (
    id_cat_mes integer NOT NULL,
    numero_mes integer,
    nombre character varying(30),
    fecha_creacion timestamp without time zone
);
     DROP TABLE general.tbl_cat_mes;
       general         heap    vince    false    13            .           1259    24764    tbl_cat_mes_id_cat_mes_seq    SEQUENCE     �   CREATE SEQUENCE general.tbl_cat_mes_id_cat_mes_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE general.tbl_cat_mes_id_cat_mes_seq;
       general          vince    false    13    303            �           0    0    tbl_cat_mes_id_cat_mes_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE general.tbl_cat_mes_id_cat_mes_seq OWNED BY general.tbl_cat_mes.id_cat_mes;
          general          vince    false    302                       1259    24270    tbl_bit_aplicacion_registro    TABLE     �  CREATE TABLE nova_aplicacion.tbl_bit_aplicacion_registro (
    id_bit_aplicacion_registro integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    id_cat_aplicacion integer NOT NULL,
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    id_bit_tarea_registro integer,
    descripcion character varying(600)
);
 8   DROP TABLE nova_aplicacion.tbl_bit_aplicacion_registro;
       nova_aplicacion         heap    vince    false    8                       1259    24269 :   tbl_bit_aplicacion_registro_id_bit_aplicacion_registro_seq    SEQUENCE     7  ALTER TABLE nova_aplicacion.tbl_bit_aplicacion_registro ALTER COLUMN id_bit_aplicacion_registro ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_aplicacion.tbl_bit_aplicacion_registro_id_bit_aplicacion_registro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_aplicacion          vince    false    8    258                        1259    24261    tbl_cat_aplicacion    TABLE     b  CREATE TABLE nova_aplicacion.tbl_cat_aplicacion (
    id_cat_aplicacion integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(600),
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 /   DROP TABLE nova_aplicacion.tbl_cat_aplicacion;
       nova_aplicacion         heap    vince    false    8            �            1259    24260 (   tbl_cat_aplicacion_id_cat_aplicacion_seq    SEQUENCE       ALTER TABLE nova_aplicacion.tbl_cat_aplicacion ALTER COLUMN id_cat_aplicacion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_aplicacion.tbl_cat_aplicacion_id_cat_aplicacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_aplicacion          vince    false    256    8            I           1259    25498    tbl_bit_dispositivo_diagnostico    TABLE     �  CREATE TABLE nova_dispositivo.tbl_bit_dispositivo_diagnostico (
    id_bit_dispositivo_diagnostico integer NOT NULL,
    id_cat_dispositivo integer,
    cpu_uso numeric(20,2),
    cpu_tiempo_activo time without time zone,
    cpu_tiempo_activo_dia integer,
    ram_disponible_mb numeric(20,2),
    disco_disponible_mb numeric(20,2),
    internet_descarga_mb numeric(20,2),
    internet_carga_mb numeric(20,2),
    internet_latencia_descarga_ms integer,
    internet_latencia_carga_ms integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 =   DROP TABLE nova_dispositivo.tbl_bit_dispositivo_diagnostico;
       nova_dispositivo         heap    vince    false    12            H           1259    25497 ?   tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq    SEQUENCE     �   CREATE SEQUENCE nova_dispositivo.tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 `   DROP SEQUENCE nova_dispositivo.tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq;
       nova_dispositivo          vince    false    12    329            �           0    0 ?   tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE nova_dispositivo.tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq OWNED BY nova_dispositivo.tbl_bit_dispositivo_diagnostico.id_bit_dispositivo_diagnostico;
          nova_dispositivo          vince    false    328                       1259    24465    tbl_cat_dispositivo    TABLE     �  CREATE TABLE nova_dispositivo.tbl_cat_dispositivo (
    id_cat_dispositivo integer NOT NULL,
    hostname character varying(100),
    ip character varying(45),
    sistema_operativo character varying(100),
    cpu_nombre character varying(45),
    disco_primario_total character varying(10),
    disco_primario_tipo character varying(10),
    ram_total character varying(10),
    product_id character varying(50),
    ultimo_logueo timestamp without time zone,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    modificado_por integer
);
 1   DROP TABLE nova_dispositivo.tbl_cat_dispositivo;
       nova_dispositivo         heap    vince    false    12                       1259    24464 *   tbl_cat_dispositivo_id_cat_dispositivo_seq    SEQUENCE       ALTER TABLE nova_dispositivo.tbl_cat_dispositivo ALTER COLUMN id_cat_dispositivo ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_dispositivo.tbl_cat_dispositivo_id_cat_dispositivo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_dispositivo          vince    false    285    12                       1259    24293    tbl_cat_falta    TABLE     �  CREATE TABLE nova_falta.tbl_cat_falta (
    id_cat_falta integer NOT NULL,
    id_cat_justificacion integer NOT NULL,
    id_cat_tipo_falta integer NOT NULL,
    creado_por integer NOT NULL,
    id_cat_persona_responsable integer NOT NULL,
    fecha date,
    estado integer,
    descripcion character varying(600),
    duracion time without time zone,
    fecha_creacion timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    modificado_por integer
);
 %   DROP TABLE nova_falta.tbl_cat_falta;
    
   nova_falta         heap    vince    false    9                       1259    24292    tbl_cat_falta_id_cat_falta_seq    SEQUENCE     �   ALTER TABLE nova_falta.tbl_cat_falta ALTER COLUMN id_cat_falta ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_falta.tbl_cat_falta_id_cat_falta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         
   nova_falta          vince    false    264    9                       1259    24277    tbl_cat_justificacion    TABLE     �  CREATE TABLE nova_falta.tbl_cat_justificacion (
    id_cat_justificacion integer NOT NULL,
    nombre character varying(300),
    abreviatura character varying(45),
    descripcion character varying(600),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    modificado_por integer
);
 -   DROP TABLE nova_falta.tbl_cat_justificacion;
    
   nova_falta         heap    vince    false    9                       1259    24276 .   tbl_cat_justificacion_id_cat_justificacion_seq    SEQUENCE       ALTER TABLE nova_falta.tbl_cat_justificacion ALTER COLUMN id_cat_justificacion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_falta.tbl_cat_justificacion_id_cat_justificacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         
   nova_falta          vince    false    9    260                       1259    24286    tbl_cat_tipo_falta    TABLE     6  CREATE TABLE nova_falta.tbl_cat_tipo_falta (
    id_cat_tipo_falta integer NOT NULL,
    nombre character varying(250),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actuallizacion timestamp without time zone,
    creado_por integer,
    modificado_por integer
);
 *   DROP TABLE nova_falta.tbl_cat_tipo_falta;
    
   nova_falta         heap    vince    false    9                       1259    24285 (   tbl_cat_tipo_falta_id_cat_tipo_falta_seq    SEQUENCE     	  ALTER TABLE nova_falta.tbl_cat_tipo_falta ALTER COLUMN id_cat_tipo_falta ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_falta.tbl_cat_tipo_falta_id_cat_tipo_falta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         
   nova_falta          vince    false    262    9            %           1259    24501    tbl_bit_horario_marcaje    TABLE     �  CREATE TABLE nova_horario.tbl_bit_horario_marcaje (
    id_cat_tipo_horario integer NOT NULL,
    id_cat_horario_accion integer NOT NULL,
    id_cat_dispositivo integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    fecha_hora timestamp without time zone,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actuallizacion timestamp without time zone
);
 1   DROP TABLE nova_horario.tbl_bit_horario_marcaje;
       nova_horario         heap    vince    false    11            $           1259    24500 /   tbl_bit_horario_marcaje_id_cat_tipo_horario_seq    SEQUENCE       ALTER TABLE nova_horario.tbl_bit_horario_marcaje ALTER COLUMN id_cat_tipo_horario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_horario.tbl_bit_horario_marcaje_id_cat_tipo_horario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_horario          vince    false    293    11                       1259    24476    tbl_cat_horario_accion    TABLE     @  CREATE TABLE nova_horario.tbl_cat_horario_accion (
    id_cat_horario_accion integer NOT NULL,
    accion character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 0   DROP TABLE nova_horario.tbl_cat_horario_accion;
       nova_horario         heap    vince    false    11                       1259    24475 0   tbl_cat_horario_accion_id_cat_horario_accion_seq    SEQUENCE       ALTER TABLE nova_horario.tbl_cat_horario_accion ALTER COLUMN id_cat_horario_accion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_horario.tbl_cat_horario_accion_id_cat_horario_accion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_horario          vince    false    287    11            #           1259    24494    tbl_det_horario_asignacion_dia    TABLE     u  CREATE TABLE nova_horario.tbl_det_horario_asignacion_dia (
    id_det_horario_asignacion_dia integer NOT NULL,
    id_cat_horario_accion integer NOT NULL,
    id_det_horario_asignacion_usuario integer NOT NULL,
    lunes time with time zone,
    martes time with time zone,
    miercoles time with time zone,
    jueves time with time zone,
    viernes time with time zone,
    sabado time with time zone,
    domingo time with time zone,
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actuallizacion timestamp without time zone
);
 8   DROP TABLE nova_horario.tbl_det_horario_asignacion_dia;
       nova_horario         heap    vince    false    11            "           1259    24493 ?   tbl_det_horario_asignacion_di_id_det_horario_asignacion_dia_seq    SEQUENCE     <  ALTER TABLE nova_horario.tbl_det_horario_asignacion_dia ALTER COLUMN id_det_horario_asignacion_dia ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_horario.tbl_det_horario_asignacion_di_id_det_horario_asignacion_dia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_horario          vince    false    11    291            !           1259    24483 "   tbl_det_horario_asignacion_usuario    TABLE     �  CREATE TABLE nova_horario.tbl_det_horario_asignacion_usuario (
    id_det_horario_asignacion_usuario integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    inicio date,
    fin date,
    estado integer,
    creado_por integer,
    actualizado_por integer NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 <   DROP TABLE nova_horario.tbl_det_horario_asignacion_usuario;
       nova_horario         heap    vince    false    11                        1259    24482 ?   tbl_det_horario_asignacion_us_id_det_horario_asignacion_usu_seq    SEQUENCE     D  ALTER TABLE nova_horario.tbl_det_horario_asignacion_usuario ALTER COLUMN id_det_horario_asignacion_usuario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_horario.tbl_det_horario_asignacion_us_id_det_horario_asignacion_usu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_horario          vince    false    289    11                       1259    24324    tbl_cat_sla    TABLE     V  CREATE TABLE nova_metrica.tbl_cat_sla (
    id_cat_sla integer NOT NULL,
    id_cat_sla_estado integer NOT NULL,
    minimo numeric,
    maximo numeric,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    modificado_por integer
);
 %   DROP TABLE nova_metrica.tbl_cat_sla;
       nova_metrica         heap    vince    false    10            	           1259    24301    tbl_cat_sla_campo_categoria    TABLE     I  CREATE TABLE nova_metrica.tbl_cat_sla_campo_categoria (
    id_cat_sla_campo_categoria integer NOT NULL,
    nombre character varying(100),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    modificado_por integer
);
 5   DROP TABLE nova_metrica.tbl_cat_sla_campo_categoria;
       nova_metrica         heap    vince    false    10                       1259    24308    tbl_cat_sla_campo_evaluacion    TABLE     �  CREATE TABLE nova_metrica.tbl_cat_sla_campo_evaluacion (
    id_cat_sla_campo_evaluacion integer NOT NULL,
    id_cat_sla_campo_categoria integer NOT NULL,
    nombre character varying(100),
    peso character varying(45),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_modificacion timestamp without time zone,
    creado_por integer,
    modificado_por integer
);
 6   DROP TABLE nova_metrica.tbl_cat_sla_campo_evaluacion;
       nova_metrica         heap    vince    false    10            
           1259    24307 <   tbl_cat_sla_campo_evaluacion_id_cat_sla_campo_evaluacion_seq    SEQUENCE     5  ALTER TABLE nova_metrica.tbl_cat_sla_campo_evaluacion ALTER COLUMN id_cat_sla_campo_evaluacion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_metrica.tbl_cat_sla_campo_evaluacion_id_cat_sla_campo_evaluacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_metrica          vince    false    267    10                       1259    24315    tbl_cat_sla_estado    TABLE     p  CREATE TABLE nova_metrica.tbl_cat_sla_estado (
    id_cat_sla_estado integer NOT NULL,
    nombre character varying(45),
    peso numeric,
    minimo numeric,
    maximo numeric,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    modificado_por integer
);
 ,   DROP TABLE nova_metrica.tbl_cat_sla_estado;
       nova_metrica         heap    vince    false    10                       1259    24314 (   tbl_cat_sla_estado_id_cat_sla_estado_seq    SEQUENCE       ALTER TABLE nova_metrica.tbl_cat_sla_estado ALTER COLUMN id_cat_sla_estado ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_metrica.tbl_cat_sla_estado_id_cat_sla_estado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_metrica          vince    false    269    10                       1259    24323    tbl_cat_sla_id_cat_sla_seq    SEQUENCE     �   ALTER TABLE nova_metrica.tbl_cat_sla ALTER COLUMN id_cat_sla ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_metrica.tbl_cat_sla_id_cat_sla_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_metrica          vince    false    10    271                       1259    24367    tbl_bit_tarea_comentario    TABLE     u  CREATE TABLE nova_proceso_tarea.tbl_bit_tarea_comentario (
    id_cat_comentario integer NOT NULL,
    id_bit_tarea_registro integer NOT NULL,
    descripcion character varying(600),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    modificador_por integer
);
 8   DROP TABLE nova_proceso_tarea.tbl_bit_tarea_comentario;
       nova_proceso_tarea         heap    vince    false    7                       1259    24366 .   tbl_bit_tarea_comentario_id_cat_comentario_seq    SEQUENCE     %  ALTER TABLE nova_proceso_tarea.tbl_bit_tarea_comentario ALTER COLUMN id_cat_comentario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_proceso_tarea.tbl_bit_tarea_comentario_id_cat_comentario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_proceso_tarea          vince    false    7    281                       1259    24360    tbl_bit_tarea_registro    TABLE     �  CREATE TABLE nova_proceso_tarea.tbl_bit_tarea_registro (
    id_bit_tarea_registro integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    id_cat_tarea_estado integer NOT NULL,
    id_cat_tarea integer NOT NULL,
    fecha date,
    inicio timestamp without time zone,
    fin timestamp without time zone,
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 6   DROP TABLE nova_proceso_tarea.tbl_bit_tarea_registro;
       nova_proceso_tarea         heap    vince    false    7                       1259    24359 0   tbl_bit_tarea_registro_id_bit_tarea_registro_seq    SEQUENCE     )  ALTER TABLE nova_proceso_tarea.tbl_bit_tarea_registro ALTER COLUMN id_bit_tarea_registro ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_proceso_tarea.tbl_bit_tarea_registro_id_bit_tarea_registro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_proceso_tarea          vince    false    7    279                       1259    24333    tbl_cat_proceso    TABLE     �  CREATE TABLE nova_proceso_tarea.tbl_cat_proceso (
    id_cat_proceso integer NOT NULL,
    id_cat_equipo integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(600),
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 /   DROP TABLE nova_proceso_tarea.tbl_cat_proceso;
       nova_proceso_tarea         heap    vince    false    7                       1259    24332 "   tbl_cat_proceso_id_cat_proceso_seq    SEQUENCE       ALTER TABLE nova_proceso_tarea.tbl_cat_proceso ALTER COLUMN id_cat_proceso ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_proceso_tarea.tbl_cat_proceso_id_cat_proceso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_proceso_tarea          vince    false    7    273                       1259    24342    tbl_cat_tarea    TABLE     �  CREATE TABLE nova_proceso_tarea.tbl_cat_tarea (
    id_cat_tarea integer NOT NULL,
    id_cat_proceso integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(600),
    inactividad_permitida integer,
    productivo integer,
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 -   DROP TABLE nova_proceso_tarea.tbl_cat_tarea;
       nova_proceso_tarea         heap    vince    false    7                       1259    24351    tbl_cat_tarea_estado    TABLE     i  CREATE TABLE nova_proceso_tarea.tbl_cat_tarea_estado (
    id_cat_tarea_estado integer NOT NULL,
    nombre character varying(255),
    descripcion character varying(600),
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 4   DROP TABLE nova_proceso_tarea.tbl_cat_tarea_estado;
       nova_proceso_tarea         heap    vince    false    7                       1259    24350 ,   tbl_cat_tarea_estado_id_cat_tarea_estado_seq    SEQUENCE     !  ALTER TABLE nova_proceso_tarea.tbl_cat_tarea_estado ALTER COLUMN id_cat_tarea_estado ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_proceso_tarea.tbl_cat_tarea_estado_id_cat_tarea_estado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_proceso_tarea          vince    false    7    277                       1259    24341    tbl_cat_tarea_id_cat_tarea_seq    SEQUENCE       ALTER TABLE nova_proceso_tarea.tbl_cat_tarea ALTER COLUMN id_cat_tarea ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_proceso_tarea.tbl_cat_tarea_id_cat_tarea_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_proceso_tarea          vince    false    275    7                       1259    24376 !   tbl_det_proceso_asignacion_puesto    TABLE     �  CREATE TABLE nova_proceso_tarea.tbl_det_proceso_asignacion_puesto (
    id_det_proceso_asignacion_puesto integer NOT NULL,
    id_cat_proceso integer NOT NULL,
    id_cat_puesto integer NOT NULL,
    estado integer,
    creado_por integer,
    modificado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 A   DROP TABLE nova_proceso_tarea.tbl_det_proceso_asignacion_puesto;
       nova_proceso_tarea         heap    vince    false    7                       1259    24375 ?   tbl_det_tarea_asignacion_pues_id_det_tarea_asignacion_usuar_seq    SEQUENCE     N  ALTER TABLE nova_proceso_tarea.tbl_det_proceso_asignacion_puesto ALTER COLUMN id_det_proceso_asignacion_puesto ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_proceso_tarea.tbl_det_tarea_asignacion_pues_id_det_tarea_asignacion_usuar_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_proceso_tarea          vince    false    283    7            ?           1259    24906    tbl_bit_ticket    TABLE     !  CREATE TABLE nova_ticket.tbl_bit_ticket (
    id_bit_ticket integer NOT NULL,
    id_cat_ticket_tipo integer NOT NULL,
    referencia character varying(20),
    resumen character varying(255),
    descripcion character varying(600),
    id_cat_equipo integer,
    id_cat_ticket_estado_proceso integer NOT NULL,
    id_cat_ticket_estado_resolucion integer NOT NULL,
    referencia_ticket_padre character varying(20),
    fecha_asignacion timestamp without time zone,
    fecha_resolucion timestamp without time zone,
    fecha_ultima_vista timestamp without time zone,
    fecha_primera_respuesta timestamp without time zone,
    fecha_vencimiento timestamp without time zone,
    usuario_responsable integer,
    usuario_solicitante integer NOT NULL,
    id_cat_proceso integer,
    id_cat_ticket_canal integer NOT NULL,
    id_cat_ticket_prioridad integer NOT NULL,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 '   DROP TABLE nova_ticket.tbl_bit_ticket;
       nova_ticket         heap    vince    false    14            E           1259    24931    tbl_bit_ticket_detalle_accion    TABLE     �  CREATE TABLE nova_ticket.tbl_bit_ticket_detalle_accion (
    id_bit_ticket_detalle_accion integer NOT NULL,
    id_bit_ticket integer NOT NULL,
    id_cat_usuario integer,
    id_cat_ticket_accion integer NOT NULL,
    antes character varying(255),
    despues character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    campo character varying(255)
);
 6   DROP TABLE nova_ticket.tbl_bit_ticket_detalle_accion;
       nova_ticket         heap    vince    false    14            D           1259    24930 >   tbl_bit_ticket_detalle_accion_id_bit_ticket_detalle_accion_seq    SEQUENCE     7  ALTER TABLE nova_ticket.tbl_bit_ticket_detalle_accion ALTER COLUMN id_bit_ticket_detalle_accion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_bit_ticket_detalle_accion_id_bit_ticket_detalle_accion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    14    325            A           1259    24915 !   tbl_bit_ticket_detalle_comentario    TABLE     �  CREATE TABLE nova_ticket.tbl_bit_ticket_detalle_comentario (
    id_bit_ticket_detalle_comentario integer NOT NULL,
    id_bit_ticket integer NOT NULL,
    id_cat_usuario integer,
    descripcion character varying(600),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 :   DROP TABLE nova_ticket.tbl_bit_ticket_detalle_comentario;
       nova_ticket         heap    vince    false    14            @           1259    24914 ?   tbl_bit_ticket_detalle_coment_id_bit_ticket_detalle_comenta_seq    SEQUENCE     @  ALTER TABLE nova_ticket.tbl_bit_ticket_detalle_comentario ALTER COLUMN id_bit_ticket_detalle_comentario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_bit_ticket_detalle_coment_id_bit_ticket_detalle_comenta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    14    321            >           1259    24905     tbl_bit_ticket_id_bit_ticket_seq    SEQUENCE     �   ALTER TABLE nova_ticket.tbl_bit_ticket ALTER COLUMN id_bit_ticket ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_bit_ticket_id_bit_ticket_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    14    319            C           1259    24924    tbl_bit_ticket_seguimiento    TABLE     d  CREATE TABLE nova_ticket.tbl_bit_ticket_seguimiento (
    id_bit_ticket_seguimiento integer NOT NULL,
    id_bit_ticket integer NOT NULL,
    id_cat_usuario integer,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 3   DROP TABLE nova_ticket.tbl_bit_ticket_seguimiento;
       nova_ticket         heap    vince    false    14            B           1259    24923 8   tbl_bit_ticket_seguimiento_id_bit_ticket_seguimiento_seq    SEQUENCE     +  ALTER TABLE nova_ticket.tbl_bit_ticket_seguimiento ALTER COLUMN id_bit_ticket_seguimiento ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_bit_ticket_seguimiento_id_bit_ticket_seguimiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    323    14            G           1259    25063    tbl_bit_ticket_vista    TABLE     O  CREATE TABLE nova_ticket.tbl_bit_ticket_vista (
    id_bit_ticket_vista integer NOT NULL,
    id_bit_ticket integer,
    id_cat_usuario integer,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 -   DROP TABLE nova_ticket.tbl_bit_ticket_vista;
       nova_ticket         heap    vince    false    14            F           1259    25062 ,   tbl_bit_ticket_vista_id_bit_ticket_vista_seq    SEQUENCE     �   CREATE SEQUENCE nova_ticket.tbl_bit_ticket_vista_id_bit_ticket_vista_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE nova_ticket.tbl_bit_ticket_vista_id_bit_ticket_vista_seq;
       nova_ticket          vince    false    327    14            �           0    0 ,   tbl_bit_ticket_vista_id_bit_ticket_vista_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE nova_ticket.tbl_bit_ticket_vista_id_bit_ticket_vista_seq OWNED BY nova_ticket.tbl_bit_ticket_vista.id_bit_ticket_vista;
          nova_ticket          vince    false    326            3           1259    24841    tbl_cat_ticket_accion    TABLE     =  CREATE TABLE nova_ticket.tbl_cat_ticket_accion (
    id_cat_ticket_accion integer NOT NULL,
    nombre character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 .   DROP TABLE nova_ticket.tbl_cat_ticket_accion;
       nova_ticket         heap    vince    false    14            2           1259    24840 .   tbl_cat_ticket_accion_id_cat_ticket_accion_seq    SEQUENCE       ALTER TABLE nova_ticket.tbl_cat_ticket_accion ALTER COLUMN id_cat_ticket_accion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_cat_ticket_accion_id_cat_ticket_accion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    307    14            =           1259    24899    tbl_cat_ticket_canal    TABLE     ;  CREATE TABLE nova_ticket.tbl_cat_ticket_canal (
    id_cat_ticket_canal integer NOT NULL,
    nombre character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 -   DROP TABLE nova_ticket.tbl_cat_ticket_canal;
       nova_ticket         heap    vince    false    14            <           1259    24898 ,   tbl_cat_ticket_canal_id_cat_ticket_canal_seq    SEQUENCE       ALTER TABLE nova_ticket.tbl_cat_ticket_canal ALTER COLUMN id_cat_ticket_canal ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_cat_ticket_canal_id_cat_ticket_canal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    14    317            7           1259    24855    tbl_cat_ticket_estado_proceso    TABLE     t  CREATE TABLE nova_ticket.tbl_cat_ticket_estado_proceso (
    id_cat_ticket_estado_proceso integer NOT NULL,
    nombre character varying(50),
    descripcion character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 6   DROP TABLE nova_ticket.tbl_cat_ticket_estado_proceso;
       nova_ticket         heap    vince    false    14            6           1259    24854 >   tbl_cat_ticket_estado_proceso_id_cat_ticket_estado_proceso_seq    SEQUENCE     7  ALTER TABLE nova_ticket.tbl_cat_ticket_estado_proceso ALTER COLUMN id_cat_ticket_estado_proceso ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_cat_ticket_estado_proceso_id_cat_ticket_estado_proceso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    14    311            9           1259    24862     tbl_cat_ticket_estado_resolucion    TABLE     z  CREATE TABLE nova_ticket.tbl_cat_ticket_estado_resolucion (
    id_cat_ticket_estado_resolucion integer NOT NULL,
    nombre character varying(50),
    descripcion character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 9   DROP TABLE nova_ticket.tbl_cat_ticket_estado_resolucion;
       nova_ticket         heap    vince    false    14            8           1259    24861 ?   tbl_cat_ticket_estado_resoluc_id_cat_ticket_estado_resoluci_seq    SEQUENCE     >  ALTER TABLE nova_ticket.tbl_cat_ticket_estado_resolucion ALTER COLUMN id_cat_ticket_estado_resolucion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_cat_ticket_estado_resoluc_id_cat_ticket_estado_resoluci_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    14    313            ;           1259    24892    tbl_cat_ticket_prioridad    TABLE     C  CREATE TABLE nova_ticket.tbl_cat_ticket_prioridad (
    id_cat_ticket_prioridad integer NOT NULL,
    nombre character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 1   DROP TABLE nova_ticket.tbl_cat_ticket_prioridad;
       nova_ticket         heap    vince    false    14            :           1259    24891 4   tbl_cat_ticket_prioridad_id_cat_ticket_prioridad_seq    SEQUENCE     #  ALTER TABLE nova_ticket.tbl_cat_ticket_prioridad ALTER COLUMN id_cat_ticket_prioridad ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_cat_ticket_prioridad_id_cat_ticket_prioridad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    315    14            5           1259    24848    tbl_cat_ticket_tipo    TABLE     8  CREATE TABLE nova_ticket.tbl_cat_ticket_tipo (
    id_cat_ticket_tipo integer NOT NULL,
    nombre character varying(50),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 ,   DROP TABLE nova_ticket.tbl_cat_ticket_tipo;
       nova_ticket         heap    vince    false    14            4           1259    24847 *   tbl_cat_ticket_tipo_id_cat_ticket_tipo_seq    SEQUENCE       ALTER TABLE nova_ticket.tbl_cat_ticket_tipo ALTER COLUMN id_cat_ticket_tipo ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME nova_ticket.tbl_cat_ticket_tipo_id_cat_ticket_tipo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            nova_ticket          vince    false    14    309            �           1259    26516    tbl_bit_version_detalle    TABLE     �  CREATE TABLE nova_version.tbl_bit_version_detalle (
    id_bit_version_detalle integer NOT NULL,
    id_cat_version integer NOT NULL,
    id_cat_version_categoria integer NOT NULL,
    descripcion text,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-02-02 14:28:58.397068'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 1   DROP TABLE nova_version.tbl_bit_version_detalle;
       nova_version         heap    vince    false    23            �           0    0 -   COLUMN tbl_bit_version_detalle.id_cat_version    COMMENT     }   COMMENT ON COLUMN nova_version.tbl_bit_version_detalle.id_cat_version IS 'hace referencia al id del catalogo de la version';
          nova_version          vince    false    388            �           0    0 7   COLUMN tbl_bit_version_detalle.id_cat_version_categoria    COMMENT     �   COMMENT ON COLUMN nova_version.tbl_bit_version_detalle.id_cat_version_categoria IS 'esta tabla hace referencia al catalogo del tipo que puede contener si es una nueva caracteristica, problema solucionado, un bug, etc.';
          nova_version          vince    false    388            �           1259    26515 2   tbl_bit_version_detalle_id_bit_version_detalle_seq    SEQUENCE     �   CREATE SEQUENCE nova_version.tbl_bit_version_detalle_id_bit_version_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 O   DROP SEQUENCE nova_version.tbl_bit_version_detalle_id_bit_version_detalle_seq;
       nova_version          vince    false    388    23            �           0    0 2   tbl_bit_version_detalle_id_bit_version_detalle_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE nova_version.tbl_bit_version_detalle_id_bit_version_detalle_seq OWNED BY nova_version.tbl_bit_version_detalle.id_bit_version_detalle;
          nova_version          vince    false    387            �           1259    26526    tbl_bit_version_detalle_resumen    TABLE     �  CREATE TABLE nova_version.tbl_bit_version_detalle_resumen (
    id_bit_version_detalle_resumen integer NOT NULL,
    id_bit_version_detalle integer NOT NULL,
    descripcion text,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-02-02 14:29:01.251929'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 9   DROP TABLE nova_version.tbl_bit_version_detalle_resumen;
       nova_version         heap    vince    false    23            �           1259    26525 ?   tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq    SEQUENCE     �   CREATE SEQUENCE nova_version.tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 \   DROP SEQUENCE nova_version.tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq;
       nova_version          vince    false    390    23            �           0    0 ?   tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE nova_version.tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq OWNED BY nova_version.tbl_bit_version_detalle_resumen.id_bit_version_detalle_resumen;
          nova_version          vince    false    389            �           1259    26498    tbl_cat_version    TABLE     �  CREATE TABLE nova_version.tbl_cat_version (
    id_cat_version integer NOT NULL,
    nombe character varying(255),
    nivel_uno integer,
    nivel_dos integer,
    nivel_tres integer,
    fecha_lanzamiento date,
    es_produccion boolean,
    descripcion text,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-02-02 14:28:44.131706'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 )   DROP TABLE nova_version.tbl_cat_version;
       nova_version         heap    vince    false    23            �           1259    26508    tbl_cat_version_categoria    TABLE     z  CREATE TABLE nova_version.tbl_cat_version_categoria (
    id_cat_version_categoria integer NOT NULL,
    nombre character varying(100),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT '2023-02-02 14:28:47.244563'::timestamp without time zone,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 3   DROP TABLE nova_version.tbl_cat_version_categoria;
       nova_version         heap    vince    false    23            �           1259    26507 6   tbl_cat_version_categoria_id_cat_version_categoria_seq    SEQUENCE     �   CREATE SEQUENCE nova_version.tbl_cat_version_categoria_id_cat_version_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 S   DROP SEQUENCE nova_version.tbl_cat_version_categoria_id_cat_version_categoria_seq;
       nova_version          vince    false    23    386            �           0    0 6   tbl_cat_version_categoria_id_cat_version_categoria_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE nova_version.tbl_cat_version_categoria_id_cat_version_categoria_seq OWNED BY nova_version.tbl_cat_version_categoria.id_cat_version_categoria;
          nova_version          vince    false    385                       1259    26497 "   tbl_cat_version_id_cat_version_seq    SEQUENCE     �   CREATE SEQUENCE nova_version.tbl_cat_version_id_cat_version_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE nova_version.tbl_cat_version_id_cat_version_seq;
       nova_version          vince    false    384    23            �           0    0 "   tbl_cat_version_id_cat_version_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE nova_version.tbl_cat_version_id_cat_version_seq OWNED BY nova_version.tbl_cat_version.id_cat_version;
          nova_version          vince    false    383            �            1259    23879    tbl_cat_aplicativo    TABLE     `  CREATE TABLE usuarios.tbl_cat_aplicativo (
    id_cat_aplicativo integer NOT NULL,
    nombre character varying(250) DEFAULT NULL::character varying,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 (   DROP TABLE usuarios.tbl_cat_aplicativo;
       usuarios         heap    vince    false    6            �            1259    23878 (   tbl_cat_aplicativo_id_cat_aplicativo_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_aplicativo_id_cat_aplicativo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE usuarios.tbl_cat_aplicativo_id_cat_aplicativo_seq;
       usuarios          vince    false    6    229            �           0    0 (   tbl_cat_aplicativo_id_cat_aplicativo_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE usuarios.tbl_cat_aplicativo_id_cat_aplicativo_seq OWNED BY usuarios.tbl_cat_aplicativo.id_cat_aplicativo;
          usuarios          vince    false    228            �            1259    23915    tbl_cat_departamento    TABLE     �  CREATE TABLE usuarios.tbl_cat_departamento (
    id_cat_departamento integer NOT NULL,
    id_cat_empresa integer NOT NULL,
    nombre character varying(250) DEFAULT NULL::character varying,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 *   DROP TABLE usuarios.tbl_cat_departamento;
       usuarios         heap    vince    false    6            �            1259    23914 ,   tbl_cat_departamento_id_cat_departamento_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_departamento_id_cat_departamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE usuarios.tbl_cat_departamento_id_cat_departamento_seq;
       usuarios          vince    false    6    236            �           0    0 ,   tbl_cat_departamento_id_cat_departamento_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_cat_departamento_id_cat_departamento_seq OWNED BY usuarios.tbl_cat_departamento.id_cat_departamento;
          usuarios          vince    false    235            �            1259    23906    tbl_cat_empresa    TABLE     Z  CREATE TABLE usuarios.tbl_cat_empresa (
    id_cat_empresa integer NOT NULL,
    nombre character varying(250) DEFAULT NULL::character varying,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 %   DROP TABLE usuarios.tbl_cat_empresa;
       usuarios         heap    vince    false    6            �            1259    23905 "   tbl_cat_empresa_id_cat_empresa_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_empresa_id_cat_empresa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE usuarios.tbl_cat_empresa_id_cat_empresa_seq;
       usuarios          vince    false    6    234            �           0    0 "   tbl_cat_empresa_id_cat_empresa_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE usuarios.tbl_cat_empresa_id_cat_empresa_seq OWNED BY usuarios.tbl_cat_empresa.id_cat_empresa;
          usuarios          vince    false    233            �            1259    23924    tbl_cat_equipo    TABLE     �  CREATE TABLE usuarios.tbl_cat_equipo (
    id_cat_equipo integer NOT NULL,
    id_cat_departamento integer NOT NULL,
    nombre character varying(250) DEFAULT NULL::character varying,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 $   DROP TABLE usuarios.tbl_cat_equipo;
       usuarios         heap    vince    false    6            �            1259    23923     tbl_cat_equipo_id_cat_equipo_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_equipo_id_cat_equipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE usuarios.tbl_cat_equipo_id_cat_equipo_seq;
       usuarios          vince    false    6    238            �           0    0     tbl_cat_equipo_id_cat_equipo_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE usuarios.tbl_cat_equipo_id_cat_equipo_seq OWNED BY usuarios.tbl_cat_equipo.id_cat_equipo;
          usuarios          vince    false    237            �            1259    23977    tbl_cat_permiso_accion    TABLE     �  CREATE TABLE usuarios.tbl_cat_permiso_accion (
    id_cat_permiso_accion integer NOT NULL,
    nombre character varying(250) DEFAULT NULL::character varying,
    descripcion character varying(600),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 ,   DROP TABLE usuarios.tbl_cat_permiso_accion;
       usuarios         heap    vince    false    6            �            1259    23976 0   tbl_cat_permiso_accion_id_cat_permiso_accion_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_permiso_accion_id_cat_permiso_accion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 I   DROP SEQUENCE usuarios.tbl_cat_permiso_accion_id_cat_permiso_accion_seq;
       usuarios          vince    false    6    250            �           0    0 0   tbl_cat_permiso_accion_id_cat_permiso_accion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_cat_permiso_accion_id_cat_permiso_accion_seq OWNED BY usuarios.tbl_cat_permiso_accion.id_cat_permiso_accion;
          usuarios          vince    false    249            �            1259    23952    tbl_cat_permiso_grupo    TABLE     �  CREATE TABLE usuarios.tbl_cat_permiso_grupo (
    id_cat_permiso_grupo integer NOT NULL,
    id_cat_permiso_nivel integer NOT NULL,
    nombre character varying(250) DEFAULT NULL::character varying,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 +   DROP TABLE usuarios.tbl_cat_permiso_grupo;
       usuarios         heap    vince    false    6            �            1259    23951 .   tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 G   DROP SEQUENCE usuarios.tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq;
       usuarios          vince    false    6    244            �           0    0 .   tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq OWNED BY usuarios.tbl_cat_permiso_grupo.id_cat_permiso_grupo;
          usuarios          vince    false    243            �            1259    23941    tbl_cat_permiso_nivel    TABLE     �  CREATE TABLE usuarios.tbl_cat_permiso_nivel (
    id_cat_permiso_nivel integer NOT NULL,
    nombre character varying(250) DEFAULT NULL::character varying,
    descripcion character varying(600),
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 +   DROP TABLE usuarios.tbl_cat_permiso_nivel;
       usuarios         heap    vince    false    6            �            1259    23940 .   tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 G   DROP SEQUENCE usuarios.tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq;
       usuarios          vince    false    242    6            �           0    0 .   tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq OWNED BY usuarios.tbl_cat_permiso_nivel.id_cat_permiso_nivel;
          usuarios          vince    false    241            �            1259    23888    tbl_cat_puesto    TABLE     X  CREATE TABLE usuarios.tbl_cat_puesto (
    id_cat_puesto integer NOT NULL,
    nombre character varying(450) DEFAULT NULL::character varying,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 $   DROP TABLE usuarios.tbl_cat_puesto;
       usuarios         heap    vince    false    6            �            1259    23887     tbl_cat_puesto_id_cat_puesto_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_puesto_id_cat_puesto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE usuarios.tbl_cat_puesto_id_cat_puesto_seq;
       usuarios          vince    false    231    6            �           0    0     tbl_cat_puesto_id_cat_puesto_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE usuarios.tbl_cat_puesto_id_cat_puesto_seq OWNED BY usuarios.tbl_cat_puesto.id_cat_puesto;
          usuarios          vince    false    230            K           1259    25729    tbl_cat_usuario_categoria    TABLE     B  CREATE TABLE usuarios.tbl_cat_usuario_categoria (
    id_cat_usuario_categoria integer NOT NULL,
    nombre character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 /   DROP TABLE usuarios.tbl_cat_usuario_categoria;
       usuarios         heap    vince    false    6            J           1259    25728 ?   tbl_cat_usuario_categoria_id_cat_ticket_solicitante_categor_seq    SEQUENCE     *  ALTER TABLE usuarios.tbl_cat_usuario_categoria ALTER COLUMN id_cat_usuario_categoria ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME usuarios.tbl_cat_usuario_categoria_id_cat_ticket_solicitante_categor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            usuarios          vince    false    6    331            M           1259    25736    tbl_cat_usuario_dominio    TABLE     W  CREATE TABLE usuarios.tbl_cat_usuario_dominio (
    id_cat_usuario_dominio integer NOT NULL,
    nombre character varying(255),
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    responsable integer
);
 -   DROP TABLE usuarios.tbl_cat_usuario_dominio;
       usuarios         heap    vince    false    6            L           1259    25735 1   tbl_cat_usuario_dominio_id_cat_ticket_dominio_seq    SEQUENCE       ALTER TABLE usuarios.tbl_cat_usuario_dominio ALTER COLUMN id_cat_usuario_dominio ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME usuarios.tbl_cat_usuario_dominio_id_cat_ticket_dominio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            usuarios          vince    false    6    333            �           1259    26932 "   tbl_cat_usuario_id_cat_usuario_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_cat_usuario_id_cat_usuario_seq
    START WITH 78
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 ;   DROP SEQUENCE usuarios.tbl_cat_usuario_id_cat_usuario_seq;
       usuarios          vince    false    232    6            �           0    0 "   tbl_cat_usuario_id_cat_usuario_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE usuarios.tbl_cat_usuario_id_cat_usuario_seq OWNED BY usuarios.tbl_cat_usuario.id_cat_usuario;
          usuarios          vince    false    391            +           1259    24638 +   tbl_det_departamento_asignacion_responsable    TABLE     �  CREATE TABLE usuarios.tbl_det_departamento_asignacion_responsable (
    id_det_departamento_asignacion_responsable integer NOT NULL,
    id_cat_departamento integer,
    id_cat_usuario integer,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 A   DROP TABLE usuarios.tbl_det_departamento_asignacion_responsable;
       usuarios         heap    vince    false    6            *           1259    24637 ?   tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq;
       usuarios          vince    false    299    6            �           0    0 ?   tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq OWNED BY usuarios.tbl_det_departamento_asignacion_responsable.id_det_departamento_asignacion_responsable;
          usuarios          vince    false    298            )           1259    24632 &   tbl_det_empresa_asignacion_responsable    TABLE     q  CREATE TABLE usuarios.tbl_det_empresa_asignacion_responsable (
    id_det_empresa_asignacion_responsable integer NOT NULL,
    id_cat_empresa integer,
    id_cat_usuario integer,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 <   DROP TABLE usuarios.tbl_det_empresa_asignacion_responsable;
       usuarios         heap    vince    false    6            (           1259    24631 ?   tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq;
       usuarios          vince    false    6    297            �           0    0 ?   tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq OWNED BY usuarios.tbl_det_empresa_asignacion_responsable.id_det_empresa_asignacion_responsable;
          usuarios          vince    false    296            -           1259    24644 %   tbl_det_equipo_asignacion_responsable    TABLE     n  CREATE TABLE usuarios.tbl_det_equipo_asignacion_responsable (
    id_det_equipo_asignacion_responsable integer NOT NULL,
    id_cat_equipo integer,
    id_cat_usuario integer,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 ;   DROP TABLE usuarios.tbl_det_equipo_asignacion_responsable;
       usuarios         heap    vince    false    6            ,           1259    24643 ?   tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq;
       usuarios          vince    false    301    6            �           0    0 ?   tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq OWNED BY usuarios.tbl_det_equipo_asignacion_responsable.id_det_equipo_asignacion_responsable;
          usuarios          vince    false    300            �            1259    23969 #   tbl_det_grupo_asignacion_aplicativo    TABLE     �  CREATE TABLE usuarios.tbl_det_grupo_asignacion_aplicativo (
    id_det_grupo_asignacion_aplicativo integer NOT NULL,
    id_cat_permiso_grupo integer NOT NULL,
    id_cat_aplicativo integer NOT NULL,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 9   DROP TABLE usuarios.tbl_det_grupo_asignacion_aplicativo;
       usuarios         heap    vince    false    6            �            1259    23968 ?   tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq;
       usuarios          vince    false    6    248            �           0    0 ?   tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq OWNED BY usuarios.tbl_det_grupo_asignacion_aplicativo.id_det_grupo_asignacion_aplicativo;
          usuarios          vince    false    247            �            1259    23988    tbl_det_nivel_asignacion_accion    TABLE     �  CREATE TABLE usuarios.tbl_det_nivel_asignacion_accion (
    id_det_accion_asignacion_nivel integer NOT NULL,
    id_cat_permiso_accion integer NOT NULL,
    id_cat_permiso_nivel integer NOT NULL,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 5   DROP TABLE usuarios.tbl_det_nivel_asignacion_accion;
       usuarios         heap    vince    false    6            �            1259    23987 ?   tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq;
       usuarios          vince    false    252    6            �           0    0 ?   tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq OWNED BY usuarios.tbl_det_nivel_asignacion_accion.id_det_accion_asignacion_nivel;
          usuarios          vince    false    251            1           1259    24808     tbl_det_puesto_asignacion_equipo    TABLE     c  CREATE TABLE usuarios.tbl_det_puesto_asignacion_equipo (
    id_det_puesto_asignacion_equipo integer NOT NULL,
    id_cat_puesto integer,
    id_cat_equipo integer,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone
);
 6   DROP TABLE usuarios.tbl_det_puesto_asignacion_equipo;
       usuarios         heap    vince    false    6            0           1259    24807 ?   tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq;
       usuarios          vince    false    6    305            �           0    0 ?   tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq OWNED BY usuarios.tbl_det_puesto_asignacion_equipo.id_det_puesto_asignacion_equipo;
          usuarios          vince    false    304            �            1259    23933 !   tbl_det_usuario_asignacion_equipo    TABLE     �  CREATE TABLE usuarios.tbl_det_usuario_asignacion_equipo (
    id_det_usuario_asignacion_equipo integer NOT NULL,
    id_cat_equipo integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 7   DROP TABLE usuarios.tbl_det_usuario_asignacion_equipo;
       usuarios         heap    vince    false    6            �            1259    23932 ?   tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq;
       usuarios          vince    false    240    6            �           0    0 ?   tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq OWNED BY usuarios.tbl_det_usuario_asignacion_equipo.id_det_usuario_asignacion_equipo;
          usuarios          vince    false    239            �            1259    23961 "   tbl_det_usuario_asignacion_permiso    TABLE     �  CREATE TABLE usuarios.tbl_det_usuario_asignacion_permiso (
    id_det_usuario_asignacion_permiso integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    id_cat_permiso_grupo integer NOT NULL,
    estado integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    creado_por integer,
    actualizado_por integer
);
 8   DROP TABLE usuarios.tbl_det_usuario_asignacion_permiso;
       usuarios         heap    vince    false    6            �            1259    23960 ?   tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq    SEQUENCE     �   CREATE SEQUENCE usuarios.tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 X   DROP SEQUENCE usuarios.tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq;
       usuarios          vince    false    246    6            �           0    0 ?   tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE usuarios.tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq OWNED BY usuarios.tbl_det_usuario_asignacion_permiso.id_det_usuario_asignacion_permiso;
          usuarios          vince    false    245            �            1259    24204 !   tbl_det_usuario_asignacion_puesto    TABLE     �  CREATE TABLE usuarios.tbl_det_usuario_asignacion_puesto (
    id_det_usuario_asignacion_puesto integer NOT NULL,
    id_cat_usuario integer NOT NULL,
    estado integer,
    creado_por integer,
    actualizado_por integer,
    fecha_creacion timestamp without time zone DEFAULT now(),
    fecha_actualizacion timestamp without time zone,
    predeterminado integer,
    id_det_puesto_asignacion_equipo integer
);
 7   DROP TABLE usuarios.tbl_det_usuario_asignacion_puesto;
       usuarios         heap    vince    false    6            �            1259    24203 ?   tbl_det_usuario_asignacion_pu_id_det_usuario_asignacion_pue_seq    SEQUENCE     :  ALTER TABLE usuarios.tbl_det_usuario_asignacion_puesto ALTER COLUMN id_det_usuario_asignacion_puesto ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME usuarios.tbl_det_usuario_asignacion_pu_id_det_usuario_asignacion_pue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            usuarios          vince    false    6    254            �           2604    26385    tbl_cat_cuenta id_cat_cuenta    DEFAULT     �   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta ALTER COLUMN id_cat_cuenta SET DEFAULT nextval('compras_cuenta.tbl_cat_cuenta_id_cat_cuenta_seq'::regclass);
 S   ALTER TABLE compras_cuenta.tbl_cat_cuenta ALTER COLUMN id_cat_cuenta DROP DEFAULT;
       compras_cuenta          vince    false    381    382    382            �           2604    26152 8   tbl_cat_cuenta_clasificacion id_cat_cuenta_clasificacion    DEFAULT     �   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta_clasificacion ALTER COLUMN id_cat_cuenta_clasificacion SET DEFAULT nextval('compras_cuenta.tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq'::regclass);
 o   ALTER TABLE compras_cuenta.tbl_cat_cuenta_clasificacion ALTER COLUMN id_cat_cuenta_clasificacion DROP DEFAULT;
       compras_cuenta          vince    false    370    369    370            �           2604    26097 .   tbl_cat_cuenta_bancaria id_cat_cuenta_bancaria    DEFAULT     �   ALTER TABLE ONLY compras_cuenta_bancaria.tbl_cat_cuenta_bancaria ALTER COLUMN id_cat_cuenta_bancaria SET DEFAULT nextval('compras_cuenta_bancaria.tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq'::regclass);
 n   ALTER TABLE compras_cuenta_bancaria.tbl_cat_cuenta_bancaria ALTER COLUMN id_cat_cuenta_bancaria DROP DEFAULT;
       compras_cuenta_bancaria          vince    false    358    357    358            �           2604    26071    tbl_cat_moneda id_cat_moneda    DEFAULT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_moneda ALTER COLUMN id_cat_moneda SET DEFAULT nextval('compras_orden_compra.tbl_cat_moneda_id_cat_moneda_seq'::regclass);
 Y   ALTER TABLE compras_orden_compra.tbl_cat_moneda ALTER COLUMN id_cat_moneda DROP DEFAULT;
       compras_orden_compra          vince    false    351    352    352            �           2604    26134 (   tbl_cat_orden_compra id_cat_orden_compra    DEFAULT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra ALTER COLUMN id_cat_orden_compra SET DEFAULT nextval('compras_orden_compra.tbl_cat_orden_compra_id_cat_orden_compra_seq'::regclass);
 e   ALTER TABLE compras_orden_compra.tbl_cat_orden_compra ALTER COLUMN id_cat_orden_compra DROP DEFAULT;
       compras_orden_compra          vince    false    366    365    366            �           2604    26105 6   tbl_cat_orden_compra_estado id_cat_orden_compra_estado    DEFAULT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_estado ALTER COLUMN id_cat_orden_compra_estado SET DEFAULT nextval('compras_orden_compra.tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq'::regclass);
 s   ALTER TABLE compras_orden_compra.tbl_cat_orden_compra_estado ALTER COLUMN id_cat_orden_compra_estado DROP DEFAULT;
       compras_orden_compra          vince    false    360    359    360            �           2604    26089 @   tbl_cat_orden_compra_metodo_pago id_cat_orden_compra_metodo_pago    DEFAULT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_metodo_pago ALTER COLUMN id_cat_orden_compra_metodo_pago SET DEFAULT nextval('compras_orden_compra.tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq'::regclass);
 }   ALTER TABLE compras_orden_compra.tbl_cat_orden_compra_metodo_pago ALTER COLUMN id_cat_orden_compra_metodo_pago DROP DEFAULT;
       compras_orden_compra          vince    false    356    355    356            �           2604    26081 >   tbl_cat_orden_compra_tipo_cuota id_cat_orden_compra_tipo_cuota    DEFAULT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_tipo_cuota ALTER COLUMN id_cat_orden_compra_tipo_cuota SET DEFAULT nextval('compras_orden_compra.tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq'::regclass);
 {   ALTER TABLE compras_orden_compra.tbl_cat_orden_compra_tipo_cuota ALTER COLUMN id_cat_orden_compra_tipo_cuota DROP DEFAULT;
       compras_orden_compra          vince    false    354    353    354            �           2604    26144 (   tbl_det_orden_compra id_det_orden_compra    DEFAULT     �   ALTER TABLE ONLY compras_orden_compra.tbl_det_orden_compra ALTER COLUMN id_det_orden_compra SET DEFAULT nextval('compras_orden_compra.tbl_det_orden_compra_id_det_orden_compra_seq'::regclass);
 e   ALTER TABLE compras_orden_compra.tbl_det_orden_compra ALTER COLUMN id_det_orden_compra DROP DEFAULT;
       compras_orden_compra          vince    false    367    368    368            �           2604    26211 4   tbl_bit_presupuesto_ajuste id_bit_presupuesto_ajuste    DEFAULT     �   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste ALTER COLUMN id_bit_presupuesto_ajuste SET DEFAULT nextval('compras_presupuesto.tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq'::regclass);
 p   ALTER TABLE compras_presupuesto.tbl_bit_presupuesto_ajuste ALTER COLUMN id_bit_presupuesto_ajuste DROP DEFAULT;
       compras_presupuesto          vince    false    379    380    380            �           2604    26124 &   tbl_cat_presupuesto id_cat_presupuesto    DEFAULT     �   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto ALTER COLUMN id_cat_presupuesto SET DEFAULT nextval('compras_presupuesto.tbl_cat_presupuesto_id_cat_presupuesto_seq'::regclass);
 b   ALTER TABLE compras_presupuesto.tbl_cat_presupuesto ALTER COLUMN id_cat_presupuesto DROP DEFAULT;
       compras_presupuesto          vince    false    364    363    364            �           2604    26114 4   tbl_cat_presupuesto_estado id_cat_presupuesto_estado    DEFAULT     �   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto_estado ALTER COLUMN id_cat_presupuesto_estado SET DEFAULT nextval('compras_presupuesto.tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq'::regclass);
 p   ALTER TABLE compras_presupuesto.tbl_cat_presupuesto_estado ALTER COLUMN id_cat_presupuesto_estado DROP DEFAULT;
       compras_presupuesto          vince    false    362    361    362            �           2604    26171 &   tbl_det_presupuesto id_det_presupuesto    DEFAULT     �   ALTER TABLE ONLY compras_presupuesto.tbl_det_presupuesto ALTER COLUMN id_det_presupuesto SET DEFAULT nextval('compras_presupuesto.tbl_det_presupuesto_id_det_presupuesto_seq'::regclass);
 b   ALTER TABLE compras_presupuesto.tbl_det_presupuesto ALTER COLUMN id_det_presupuesto DROP DEFAULT;
       compras_presupuesto          vince    false    372    371    372            �           2604    26021 4   tbl_cat_producto_categoria id_cat_producto_categoria    DEFAULT     �   ALTER TABLE ONLY compras_producto.tbl_cat_producto_categoria ALTER COLUMN id_cat_producto_categoria SET DEFAULT nextval('compras_producto.tbl_cat_producto_categoria_id_cat_producto_categoria_seq'::regclass);
 m   ALTER TABLE compras_producto.tbl_cat_producto_categoria ALTER COLUMN id_cat_producto_categoria DROP DEFAULT;
       compras_producto          vince    false    340    341    341            �           2604    26029 <   tbl_cat_producto_unidad_medida id_cat_producto_unidad_medida    DEFAULT     �   ALTER TABLE ONLY compras_producto.tbl_cat_producto_unidad_medida ALTER COLUMN id_cat_producto_unidad_medida SET DEFAULT nextval('compras_producto.tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq'::regclass);
 u   ALTER TABLE compras_producto.tbl_cat_producto_unidad_medida ALTER COLUMN id_cat_producto_unidad_medida DROP DEFAULT;
       compras_producto          vince    false    342    343    343            �           2604    26011 "   tbl_cat_proveedor id_cat_proveedor    DEFAULT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor ALTER COLUMN id_cat_proveedor SET DEFAULT nextval('compras_proveedor.tbl_cat_proveedor_id_cat_proveedor_seq'::regclass);
 \   ALTER TABLE compras_proveedor.tbl_cat_proveedor ALTER COLUMN id_cat_proveedor DROP DEFAULT;
       compras_proveedor          vince    false    338    339    339            �           2604    25993 ,   tbl_cat_proveedor_giro id_cat_proveedor_giro    DEFAULT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor_giro ALTER COLUMN id_cat_proveedor_giro SET DEFAULT nextval('compras_proveedor.tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq'::regclass);
 f   ALTER TABLE compras_proveedor.tbl_cat_proveedor_giro ALTER COLUMN id_cat_proveedor_giro DROP DEFAULT;
       compras_proveedor          vince    false    335    334    335            �           2604    26003 ,   tbl_cat_proveedor_tipo id_cat_proveedor_tipo    DEFAULT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor_tipo ALTER COLUMN id_cat_proveedor_tipo SET DEFAULT nextval('compras_proveedor.tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq'::regclass);
 f   ALTER TABLE compras_proveedor.tbl_cat_proveedor_tipo ALTER COLUMN id_cat_proveedor_tipo DROP DEFAULT;
       compras_proveedor          vince    false    337    336    337            �           2604    26191 "   tbl_cat_recepcion id_cat_recepcion    DEFAULT     �   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion ALTER COLUMN id_cat_recepcion SET DEFAULT nextval('compras_recepcion.tbl_cat_recepcion_id_cat_recepcion_seq'::regclass);
 \   ALTER TABLE compras_recepcion.tbl_cat_recepcion ALTER COLUMN id_cat_recepcion DROP DEFAULT;
       compras_recepcion          vince    false    375    376    376            �           2604    26181 0   tbl_cat_recepcion_estado id_cat_recepcion_estado    DEFAULT     �   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion_estado ALTER COLUMN id_cat_recepcion_estado SET DEFAULT nextval('compras_recepcion.tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq'::regclass);
 j   ALTER TABLE compras_recepcion.tbl_cat_recepcion_estado ALTER COLUMN id_cat_recepcion_estado DROP DEFAULT;
       compras_recepcion          vince    false    373    374    374            �           2604    26201 "   tbl_det_recepcion id_det_recepcion    DEFAULT     �   ALTER TABLE ONLY compras_recepcion.tbl_det_recepcion ALTER COLUMN id_det_recepcion SET DEFAULT nextval('compras_recepcion.tbl_det_recepcion_id_det_recepcion_seq'::regclass);
 \   ALTER TABLE compras_recepcion.tbl_det_recepcion ALTER COLUMN id_det_recepcion DROP DEFAULT;
       compras_recepcion          vince    false    377    378    378            �           2604    26053 "   tbl_cat_solicitud id_cat_solicitud    DEFAULT     �   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud ALTER COLUMN id_cat_solicitud SET DEFAULT nextval('compras_solicitud.tbl_cat_solicitud_id_cat_solicitud_seq'::regclass);
 \   ALTER TABLE compras_solicitud.tbl_cat_solicitud ALTER COLUMN id_cat_solicitud DROP DEFAULT;
       compras_solicitud          vince    false    347    348    348            �           2604    26043 0   tbl_cat_solicitud_estado id_cat_solicitud_estado    DEFAULT     �   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud_estado ALTER COLUMN id_cat_solicitud_estado SET DEFAULT nextval('compras_solicitud.tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq'::regclass);
 j   ALTER TABLE compras_solicitud.tbl_cat_solicitud_estado ALTER COLUMN id_cat_solicitud_estado DROP DEFAULT;
       compras_solicitud          vince    false    345    346    346            �           2604    26063 "   tbl_det_solicitud id_det_solicitud    DEFAULT     �   ALTER TABLE ONLY compras_solicitud.tbl_det_solicitud ALTER COLUMN id_det_solicitud SET DEFAULT nextval('compras_solicitud.tbl_det_solicitud_id_det_solicitud_seq'::regclass);
 \   ALTER TABLE compras_solicitud.tbl_det_solicitud ALTER COLUMN id_det_solicitud DROP DEFAULT;
       compras_solicitud          vince    false    350    349    350                       2604    26970    tbl_bit_marcaje id_bit_marcaje    DEFAULT     �   ALTER TABLE ONLY general.tbl_bit_marcaje ALTER COLUMN id_bit_marcaje SET DEFAULT nextval('general.tbl_bit_marcaje_id_bit_marcaje_seq'::regclass);
 N   ALTER TABLE general.tbl_bit_marcaje ALTER COLUMN id_bit_marcaje DROP DEFAULT;
       general          vince    false    393    392            �           2604    24595 0   tbl_bit_reporte_consulta id_bit_reporte_consulta    DEFAULT     �   ALTER TABLE ONLY general.tbl_bit_reporte_consulta ALTER COLUMN id_bit_reporte_consulta SET DEFAULT nextval('general.tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq'::regclass);
 `   ALTER TABLE general.tbl_bit_reporte_consulta ALTER COLUMN id_bit_reporte_consulta DROP DEFAULT;
       general          vince    false    294    295    295            �           2604    24768    tbl_cat_mes id_cat_mes    DEFAULT     �   ALTER TABLE ONLY general.tbl_cat_mes ALTER COLUMN id_cat_mes SET DEFAULT nextval('general.tbl_cat_mes_id_cat_mes_seq'::regclass);
 F   ALTER TABLE general.tbl_cat_mes ALTER COLUMN id_cat_mes DROP DEFAULT;
       general          vince    false    302    303    303            �           2604    25501 >   tbl_bit_dispositivo_diagnostico id_bit_dispositivo_diagnostico    DEFAULT     �   ALTER TABLE ONLY nova_dispositivo.tbl_bit_dispositivo_diagnostico ALTER COLUMN id_bit_dispositivo_diagnostico SET DEFAULT nextval('nova_dispositivo.tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq'::regclass);
 w   ALTER TABLE nova_dispositivo.tbl_bit_dispositivo_diagnostico ALTER COLUMN id_bit_dispositivo_diagnostico DROP DEFAULT;
       nova_dispositivo          vince    false    328    329    329            �           2604    25066 (   tbl_bit_ticket_vista id_bit_ticket_vista    DEFAULT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_vista ALTER COLUMN id_bit_ticket_vista SET DEFAULT nextval('nova_ticket.tbl_bit_ticket_vista_id_bit_ticket_vista_seq'::regclass);
 \   ALTER TABLE nova_ticket.tbl_bit_ticket_vista ALTER COLUMN id_bit_ticket_vista DROP DEFAULT;
       nova_ticket          vince    false    327    326    327                        2604    26519 .   tbl_bit_version_detalle id_bit_version_detalle    DEFAULT     �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle ALTER COLUMN id_bit_version_detalle SET DEFAULT nextval('nova_version.tbl_bit_version_detalle_id_bit_version_detalle_seq'::regclass);
 c   ALTER TABLE nova_version.tbl_bit_version_detalle ALTER COLUMN id_bit_version_detalle DROP DEFAULT;
       nova_version          vince    false    387    388    388                       2604    26529 >   tbl_bit_version_detalle_resumen id_bit_version_detalle_resumen    DEFAULT     �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle_resumen ALTER COLUMN id_bit_version_detalle_resumen SET DEFAULT nextval('nova_version.tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq'::regclass);
 s   ALTER TABLE nova_version.tbl_bit_version_detalle_resumen ALTER COLUMN id_bit_version_detalle_resumen DROP DEFAULT;
       nova_version          vince    false    390    389    390            �           2604    26501    tbl_cat_version id_cat_version    DEFAULT     �   ALTER TABLE ONLY nova_version.tbl_cat_version ALTER COLUMN id_cat_version SET DEFAULT nextval('nova_version.tbl_cat_version_id_cat_version_seq'::regclass);
 S   ALTER TABLE nova_version.tbl_cat_version ALTER COLUMN id_cat_version DROP DEFAULT;
       nova_version          vince    false    383    384    384            �           2604    26511 2   tbl_cat_version_categoria id_cat_version_categoria    DEFAULT     �   ALTER TABLE ONLY nova_version.tbl_cat_version_categoria ALTER COLUMN id_cat_version_categoria SET DEFAULT nextval('nova_version.tbl_cat_version_categoria_id_cat_version_categoria_seq'::regclass);
 g   ALTER TABLE nova_version.tbl_cat_version_categoria ALTER COLUMN id_cat_version_categoria DROP DEFAULT;
       nova_version          vince    false    386    385    386            y           2604    23882 $   tbl_cat_aplicativo id_cat_aplicativo    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_aplicativo ALTER COLUMN id_cat_aplicativo SET DEFAULT nextval('usuarios.tbl_cat_aplicativo_id_cat_aplicativo_seq'::regclass);
 U   ALTER TABLE usuarios.tbl_cat_aplicativo ALTER COLUMN id_cat_aplicativo DROP DEFAULT;
       usuarios          vince    false    228    229    229            �           2604    23918 (   tbl_cat_departamento id_cat_departamento    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_departamento ALTER COLUMN id_cat_departamento SET DEFAULT nextval('usuarios.tbl_cat_departamento_id_cat_departamento_seq'::regclass);
 Y   ALTER TABLE usuarios.tbl_cat_departamento ALTER COLUMN id_cat_departamento DROP DEFAULT;
       usuarios          vince    false    235    236    236            �           2604    23909    tbl_cat_empresa id_cat_empresa    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_empresa ALTER COLUMN id_cat_empresa SET DEFAULT nextval('usuarios.tbl_cat_empresa_id_cat_empresa_seq'::regclass);
 O   ALTER TABLE usuarios.tbl_cat_empresa ALTER COLUMN id_cat_empresa DROP DEFAULT;
       usuarios          vince    false    234    233    234            �           2604    23927    tbl_cat_equipo id_cat_equipo    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_equipo ALTER COLUMN id_cat_equipo SET DEFAULT nextval('usuarios.tbl_cat_equipo_id_cat_equipo_seq'::regclass);
 M   ALTER TABLE usuarios.tbl_cat_equipo ALTER COLUMN id_cat_equipo DROP DEFAULT;
       usuarios          vince    false    237    238    238            �           2604    23980 ,   tbl_cat_permiso_accion id_cat_permiso_accion    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_permiso_accion ALTER COLUMN id_cat_permiso_accion SET DEFAULT nextval('usuarios.tbl_cat_permiso_accion_id_cat_permiso_accion_seq'::regclass);
 ]   ALTER TABLE usuarios.tbl_cat_permiso_accion ALTER COLUMN id_cat_permiso_accion DROP DEFAULT;
       usuarios          vince    false    250    249    250            �           2604    23955 *   tbl_cat_permiso_grupo id_cat_permiso_grupo    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_permiso_grupo ALTER COLUMN id_cat_permiso_grupo SET DEFAULT nextval('usuarios.tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq'::regclass);
 [   ALTER TABLE usuarios.tbl_cat_permiso_grupo ALTER COLUMN id_cat_permiso_grupo DROP DEFAULT;
       usuarios          vince    false    243    244    244            �           2604    23944 *   tbl_cat_permiso_nivel id_cat_permiso_nivel    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_permiso_nivel ALTER COLUMN id_cat_permiso_nivel SET DEFAULT nextval('usuarios.tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq'::regclass);
 [   ALTER TABLE usuarios.tbl_cat_permiso_nivel ALTER COLUMN id_cat_permiso_nivel DROP DEFAULT;
       usuarios          vince    false    242    241    242            |           2604    23891    tbl_cat_puesto id_cat_puesto    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_puesto ALTER COLUMN id_cat_puesto SET DEFAULT nextval('usuarios.tbl_cat_puesto_id_cat_puesto_seq'::regclass);
 M   ALTER TABLE usuarios.tbl_cat_puesto ALTER COLUMN id_cat_puesto DROP DEFAULT;
       usuarios          vince    false    230    231    231                       2604    26933    tbl_cat_usuario id_cat_usuario    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_cat_usuario ALTER COLUMN id_cat_usuario SET DEFAULT nextval('usuarios.tbl_cat_usuario_id_cat_usuario_seq'::regclass);
 O   ALTER TABLE usuarios.tbl_cat_usuario ALTER COLUMN id_cat_usuario DROP DEFAULT;
       usuarios          vince    false    391    232            �           2604    24641 V   tbl_det_departamento_asignacion_responsable id_det_departamento_asignacion_responsable    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_departamento_asignacion_responsable ALTER COLUMN id_det_departamento_asignacion_responsable SET DEFAULT nextval('usuarios.tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq'::regclass);
 �   ALTER TABLE usuarios.tbl_det_departamento_asignacion_responsable ALTER COLUMN id_det_departamento_asignacion_responsable DROP DEFAULT;
       usuarios          vince    false    298    299    299            �           2604    24635 L   tbl_det_empresa_asignacion_responsable id_det_empresa_asignacion_responsable    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_empresa_asignacion_responsable ALTER COLUMN id_det_empresa_asignacion_responsable SET DEFAULT nextval('usuarios.tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq'::regclass);
 }   ALTER TABLE usuarios.tbl_det_empresa_asignacion_responsable ALTER COLUMN id_det_empresa_asignacion_responsable DROP DEFAULT;
       usuarios          vince    false    297    296    297            �           2604    24647 J   tbl_det_equipo_asignacion_responsable id_det_equipo_asignacion_responsable    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_equipo_asignacion_responsable ALTER COLUMN id_det_equipo_asignacion_responsable SET DEFAULT nextval('usuarios.tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq'::regclass);
 {   ALTER TABLE usuarios.tbl_det_equipo_asignacion_responsable ALTER COLUMN id_det_equipo_asignacion_responsable DROP DEFAULT;
       usuarios          vince    false    300    301    301            �           2604    23972 F   tbl_det_grupo_asignacion_aplicativo id_det_grupo_asignacion_aplicativo    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_grupo_asignacion_aplicativo ALTER COLUMN id_det_grupo_asignacion_aplicativo SET DEFAULT nextval('usuarios.tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq'::regclass);
 w   ALTER TABLE usuarios.tbl_det_grupo_asignacion_aplicativo ALTER COLUMN id_det_grupo_asignacion_aplicativo DROP DEFAULT;
       usuarios          vince    false    247    248    248            �           2604    23991 >   tbl_det_nivel_asignacion_accion id_det_accion_asignacion_nivel    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_nivel_asignacion_accion ALTER COLUMN id_det_accion_asignacion_nivel SET DEFAULT nextval('usuarios.tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq'::regclass);
 o   ALTER TABLE usuarios.tbl_det_nivel_asignacion_accion ALTER COLUMN id_det_accion_asignacion_nivel DROP DEFAULT;
       usuarios          vince    false    252    251    252            �           2604    24811 @   tbl_det_puesto_asignacion_equipo id_det_puesto_asignacion_equipo    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_puesto_asignacion_equipo ALTER COLUMN id_det_puesto_asignacion_equipo SET DEFAULT nextval('usuarios.tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq'::regclass);
 q   ALTER TABLE usuarios.tbl_det_puesto_asignacion_equipo ALTER COLUMN id_det_puesto_asignacion_equipo DROP DEFAULT;
       usuarios          vince    false    304    305    305            �           2604    23936 B   tbl_det_usuario_asignacion_equipo id_det_usuario_asignacion_equipo    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_equipo ALTER COLUMN id_det_usuario_asignacion_equipo SET DEFAULT nextval('usuarios.tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq'::regclass);
 s   ALTER TABLE usuarios.tbl_det_usuario_asignacion_equipo ALTER COLUMN id_det_usuario_asignacion_equipo DROP DEFAULT;
       usuarios          vince    false    240    239    240            �           2604    23964 D   tbl_det_usuario_asignacion_permiso id_det_usuario_asignacion_permiso    DEFAULT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_permiso ALTER COLUMN id_det_usuario_asignacion_permiso SET DEFAULT nextval('usuarios.tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq'::regclass);
 u   ALTER TABLE usuarios.tbl_det_usuario_asignacion_permiso ALTER COLUMN id_det_usuario_asignacion_permiso DROP DEFAULT;
       usuarios          vince    false    245    246    246            w          0    26382    tbl_cat_cuenta 
   TABLE DATA           �   COPY compras_cuenta.tbl_cat_cuenta (id_cat_cuenta, id_cat_cuenta_clasificacion, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_cuenta          vince    false    382   ��      k          0    26149    tbl_cat_cuenta_clasificacion 
   TABLE DATA           �   COPY compras_cuenta.tbl_cat_cuenta_clasificacion (id_cat_cuenta_clasificacion, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_cuenta          vince    false    370   ڰ      _          0    26094    tbl_cat_cuenta_bancaria 
   TABLE DATA           �   COPY compras_cuenta_bancaria.tbl_cat_cuenta_bancaria (id_cat_cuenta_bancaria, id_cat_empresa, nombre, nit, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_cuenta_bancaria          vince    false    358   T�      Y          0    26068    tbl_cat_moneda 
   TABLE DATA           �   COPY compras_orden_compra.tbl_cat_moneda (id_cat_moneda, abreviatura, monto_compra, monto_venta, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_orden_compra          vince    false    352   q�      g          0    26131    tbl_cat_orden_compra 
   TABLE DATA           a  COPY compras_orden_compra.tbl_cat_orden_compra (id_cat_orden_compra, id_cat_orden_compra_metodo_pago, id_cat_orden_compra_tipo_cuota, id_cat_moneda, solicitante, aprobador_presupuesto, aprobador_tesoreria, aprobador_extraordinario, id_cat_proveedor, numero_correlativo, cuotas, monto_cuotas, mes, id_cat_presupuesto, tamano_odc, estado_ppt, total_gastado, comentario, fecha_aprobacion_tesoreria, fecha_aprobacion_presupuesto, fecha_aprobacion_extraordinario, id_cat_orden_compra_estado, id_cat_cuenta_bancaria, dentro_presupuesto, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_orden_compra          vince    false    366   ��      a          0    26102    tbl_cat_orden_compra_estado 
   TABLE DATA           �   COPY compras_orden_compra.tbl_cat_orden_compra_estado (id_cat_orden_compra_estado, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_orden_compra          vince    false    360   ٲ      ]          0    26086     tbl_cat_orden_compra_metodo_pago 
   TABLE DATA           �   COPY compras_orden_compra.tbl_cat_orden_compra_metodo_pago (id_cat_orden_compra_metodo_pago, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_orden_compra          vince    false    356   V�      [          0    26078    tbl_cat_orden_compra_tipo_cuota 
   TABLE DATA           �   COPY compras_orden_compra.tbl_cat_orden_compra_tipo_cuota (id_cat_orden_compra_tipo_cuota, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_orden_compra          vince    false    354   ��      i          0    26141    tbl_det_orden_compra 
   TABLE DATA           �   COPY compras_orden_compra.tbl_det_orden_compra (id_det_orden_compra, id_cat_orden_compra, producto, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_orden_compra          vince    false    368   ��      u          0    26208    tbl_bit_presupuesto_ajuste 
   TABLE DATA           �   COPY compras_presupuesto.tbl_bit_presupuesto_ajuste (id_bit_presupuesto_ajuste, id_det_presupuesto, mes, cuenta_abono, cuenta_cargo, monto, justificacion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_presupuesto          vince    false    380   �      e          0    26121    tbl_cat_presupuesto 
   TABLE DATA           �   COPY compras_presupuesto.tbl_cat_presupuesto (id_cat_presupuesto, id_cat_empresa, monto, "año", usuario_responsable, id_cat_presupuesto_estado, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_presupuesto          vince    false    364   /�      c          0    26111    tbl_cat_presupuesto_estado 
   TABLE DATA           �   COPY compras_presupuesto.tbl_cat_presupuesto_estado (id_cat_presupuesto_estado, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_presupuesto          vince    false    362   д      m          0    26168    tbl_det_presupuesto 
   TABLE DATA           I  COPY compras_presupuesto.tbl_det_presupuesto (id_det_presupuesto, id_cat_presupuesto, id_cat_cuenta, monto_inicial, enero_inicial, enero_final, febrero_inicial, febrero_final, marzo_inicial, marzo_final, abril_inicial, abril_final, mayo_inicial, mayo_final, junio_inicial, junio_final, julio_inicial, julio_final, agosto_inicial, agosto_final, septiembre_inicial, septiembre_final, octubre_inicial, octubre_final, noviembre_inicial, noviembre_final, diciembre_inicial, diciembre_final, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por, monto_final) FROM stdin;
    compras_presupuesto          vince    false    372   ��      Q          0    26033    tbl_cat_producto 
   TABLE DATA           8  COPY compras_producto.tbl_cat_producto (id_cat_producto, id_cat_usuario, id_cat_producto_categoria, id_cat_producto_unidad_medida, id_cat_proveedor, nombre, descripcion, precio_compra, precio_venta, cantidad, cantidad_minima, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_producto          vince    false    344   ��      N          0    26018    tbl_cat_producto_categoria 
   TABLE DATA           �   COPY compras_producto.tbl_cat_producto_categoria (id_cat_producto_categoria, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_producto          vince    false    341   s�      P          0    26026    tbl_cat_producto_unidad_medida 
   TABLE DATA           �   COPY compras_producto.tbl_cat_producto_unidad_medida (id_cat_producto_unidad_medida, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_producto          vince    false    343   e�      L          0    26008    tbl_cat_proveedor 
   TABLE DATA             COPY compras_proveedor.tbl_cat_proveedor (id_cat_proveedor, id_cat_proveedor_giro, nombre_completo, nit, email, telefono_contacto, celular_personal, rtu_archivo, id_cat_proveedor_tipo, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por, id_cat_usuario) FROM stdin;
    compras_proveedor          vince    false    339   ��      H          0    25990    tbl_cat_proveedor_giro 
   TABLE DATA           �   COPY compras_proveedor.tbl_cat_proveedor_giro (id_cat_proveedor_giro, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_proveedor          vince    false    335   ��      J          0    26000    tbl_cat_proveedor_tipo 
   TABLE DATA           �   COPY compras_proveedor.tbl_cat_proveedor_tipo (id_cat_proveedor_tipo, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_proveedor          vince    false    337   C�      q          0    26188    tbl_cat_recepcion 
   TABLE DATA           #  COPY compras_recepcion.tbl_cat_recepcion (id_cat_recepcion, id_cat_orden_compra, id_cat_recepcion_estado, comentario, entregado_por, recibido_por, entregado_por_firma, recibido_por_firma, fecha_recepcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_recepcion          vince    false    376   ��      o          0    26178    tbl_cat_recepcion_estado 
   TABLE DATA           �   COPY compras_recepcion.tbl_cat_recepcion_estado (id_cat_recepcion_estado, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_recepcion          vince    false    374   ��      s          0    26198    tbl_det_recepcion 
   TABLE DATA              COPY compras_recepcion.tbl_det_recepcion (id_det_recepcion, id_cat_recepcion, id_cat_producto, producto, cantidad_solicitada, cantidad_recibida, diferencia, observacion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_recepcion          vince    false    378   �      U          0    26050    tbl_cat_solicitud 
   TABLE DATA           �   COPY compras_solicitud.tbl_cat_solicitud (id_cat_solicitud, id_cat_usuario, total, comentario, fecha_solicitud, id_cat_solicitud_estado, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_solicitud          vince    false    348   9�      S          0    26040    tbl_cat_solicitud_estado 
   TABLE DATA           �   COPY compras_solicitud.tbl_cat_solicitud_estado (id_cat_solicitud_estado, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_solicitud          vince    false    346   V�      W          0    26060    tbl_det_solicitud 
   TABLE DATA           �   COPY compras_solicitud.tbl_det_solicitud (id_det_solicitud, id_cat_solicitud, id_cat_producto, cantidad, comentario, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    compras_solicitud          vince    false    350   s�      �          0    26962    tbl_bit_marcaje 
   TABLE DATA           [   COPY general.tbl_bit_marcaje (id_bit_marcaje, usuario, fecha_creacion, accion) FROM stdin;
    general          vince    false    392   ��                 0    24592    tbl_bit_reporte_consulta 
   TABLE DATA           t   COPY general.tbl_bit_reporte_consulta (id_bit_reporte_consulta, usuario, reporte, fecha_hora, consulta) FROM stdin;
    general          vince    false    295   ��      (          0    24765    tbl_cat_mes 
   TABLE DATA           V   COPY general.tbl_cat_mes (id_cat_mes, numero_mes, nombre, fecha_creacion) FROM stdin;
    general          vince    false    303   K	      �          0    24270    tbl_bit_aplicacion_registro 
   TABLE DATA           �   COPY nova_aplicacion.tbl_bit_aplicacion_registro (id_bit_aplicacion_registro, id_cat_usuario, id_cat_aplicacion, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion, id_bit_tarea_registro, descripcion) FROM stdin;
    nova_aplicacion          vince    false    258   :
      �          0    24261    tbl_cat_aplicacion 
   TABLE DATA           �   COPY nova_aplicacion.tbl_cat_aplicacion (id_cat_aplicacion, nombre, descripcion, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_aplicacion          vince    false    256   `-      B          0    25498    tbl_bit_dispositivo_diagnostico 
   TABLE DATA           x  COPY nova_dispositivo.tbl_bit_dispositivo_diagnostico (id_bit_dispositivo_diagnostico, id_cat_dispositivo, cpu_uso, cpu_tiempo_activo, cpu_tiempo_activo_dia, ram_disponible_mb, disco_disponible_mb, internet_descarga_mb, internet_carga_mb, internet_latencia_descarga_ms, internet_latencia_carga_ms, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_dispositivo          vince    false    329   �4                0    24465    tbl_cat_dispositivo 
   TABLE DATA             COPY nova_dispositivo.tbl_cat_dispositivo (id_cat_dispositivo, hostname, ip, sistema_operativo, cpu_nombre, disco_primario_total, disco_primario_tipo, ram_total, product_id, ultimo_logueo, estado, fecha_creacion, fecha_actualizacion, creado_por, modificado_por) FROM stdin;
    nova_dispositivo          vince    false    285   ��                0    24293    tbl_cat_falta 
   TABLE DATA           �   COPY nova_falta.tbl_cat_falta (id_cat_falta, id_cat_justificacion, id_cat_tipo_falta, creado_por, id_cat_persona_responsable, fecha, estado, descripcion, duracion, fecha_creacion, fecha_actualizacion, modificado_por) FROM stdin;
 
   nova_falta          vince    false    264   7�      �          0    24277    tbl_cat_justificacion 
   TABLE DATA           �   COPY nova_falta.tbl_cat_justificacion (id_cat_justificacion, nombre, abreviatura, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, modificado_por) FROM stdin;
 
   nova_falta          vince    false    260   T�      �          0    24286    tbl_cat_tipo_falta 
   TABLE DATA           �   COPY nova_falta.tbl_cat_tipo_falta (id_cat_tipo_falta, nombre, estado, fecha_creacion, fecha_actuallizacion, creado_por, modificado_por) FROM stdin;
 
   nova_falta          vince    false    262   q�                0    24501    tbl_bit_horario_marcaje 
   TABLE DATA           �   COPY nova_horario.tbl_bit_horario_marcaje (id_cat_tipo_horario, id_cat_horario_accion, id_cat_dispositivo, id_cat_usuario, fecha_hora, creado_por, modificado_por, fecha_creacion, fecha_actuallizacion) FROM stdin;
    nova_horario          vince    false    293   ��                0    24476    tbl_cat_horario_accion 
   TABLE DATA           �   COPY nova_horario.tbl_cat_horario_accion (id_cat_horario_accion, accion, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_horario          vince    false    287   G�                0    24494    tbl_det_horario_asignacion_dia 
   TABLE DATA             COPY nova_horario.tbl_det_horario_asignacion_dia (id_det_horario_asignacion_dia, id_cat_horario_accion, id_det_horario_asignacion_usuario, lunes, martes, miercoles, jueves, viernes, sabado, domingo, estado, creado_por, modificado_por, fecha_creacion, fecha_actuallizacion) FROM stdin;
    nova_horario          vince    false    291   ��                0    24483 "   tbl_det_horario_asignacion_usuario 
   TABLE DATA           �   COPY nova_horario.tbl_det_horario_asignacion_usuario (id_det_horario_asignacion_usuario, id_cat_usuario, inicio, fin, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_horario          vince    false    289   Z�                0    24324    tbl_cat_sla 
   TABLE DATA           �   COPY nova_metrica.tbl_cat_sla (id_cat_sla, id_cat_sla_estado, minimo, maximo, estado, fecha_creacion, fecha_actualizacion, creado_por, modificado_por) FROM stdin;
    nova_metrica          vince    false    271   ه                0    24301    tbl_cat_sla_campo_categoria 
   TABLE DATA           �   COPY nova_metrica.tbl_cat_sla_campo_categoria (id_cat_sla_campo_categoria, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, modificado_por) FROM stdin;
    nova_metrica          vince    false    265   ��                0    24308    tbl_cat_sla_campo_evaluacion 
   TABLE DATA           �   COPY nova_metrica.tbl_cat_sla_campo_evaluacion (id_cat_sla_campo_evaluacion, id_cat_sla_campo_categoria, nombre, peso, estado, fecha_creacion, fecha_modificacion, creado_por, modificado_por) FROM stdin;
    nova_metrica          vince    false    267   �                0    24315    tbl_cat_sla_estado 
   TABLE DATA           �   COPY nova_metrica.tbl_cat_sla_estado (id_cat_sla_estado, nombre, peso, minimo, maximo, estado, fecha_creacion, fecha_actualizacion, creado_por, modificado_por) FROM stdin;
    nova_metrica          vince    false    269   0�                0    24367    tbl_bit_tarea_comentario 
   TABLE DATA           �   COPY nova_proceso_tarea.tbl_bit_tarea_comentario (id_cat_comentario, id_bit_tarea_registro, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, modificador_por) FROM stdin;
    nova_proceso_tarea          vince    false    281   M�                0    24360    tbl_bit_tarea_registro 
   TABLE DATA           �   COPY nova_proceso_tarea.tbl_bit_tarea_registro (id_bit_tarea_registro, id_cat_usuario, id_cat_tarea_estado, id_cat_tarea, fecha, inicio, fin, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_proceso_tarea          vince    false    279   ��      
          0    24333    tbl_cat_proceso 
   TABLE DATA           �   COPY nova_proceso_tarea.tbl_cat_proceso (id_cat_proceso, id_cat_equipo, nombre, descripcion, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_proceso_tarea          vince    false    273   )�                0    24342    tbl_cat_tarea 
   TABLE DATA           �   COPY nova_proceso_tarea.tbl_cat_tarea (id_cat_tarea, id_cat_proceso, nombre, descripcion, inactividad_permitida, productivo, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_proceso_tarea          vince    false    275   �                0    24351    tbl_cat_tarea_estado 
   TABLE DATA           �   COPY nova_proceso_tarea.tbl_cat_tarea_estado (id_cat_tarea_estado, nombre, descripcion, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_proceso_tarea          vince    false    277   ��                0    24376 !   tbl_det_proceso_asignacion_puesto 
   TABLE DATA           �   COPY nova_proceso_tarea.tbl_det_proceso_asignacion_puesto (id_det_proceso_asignacion_puesto, id_cat_proceso, id_cat_puesto, estado, creado_por, modificado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_proceso_tarea          vince    false    283   "�      8          0    24906    tbl_bit_ticket 
   TABLE DATA           �  COPY nova_ticket.tbl_bit_ticket (id_bit_ticket, id_cat_ticket_tipo, referencia, resumen, descripcion, id_cat_equipo, id_cat_ticket_estado_proceso, id_cat_ticket_estado_resolucion, referencia_ticket_padre, fecha_asignacion, fecha_resolucion, fecha_ultima_vista, fecha_primera_respuesta, fecha_vencimiento, usuario_responsable, usuario_solicitante, id_cat_proceso, id_cat_ticket_canal, id_cat_ticket_prioridad, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    319   f�      >          0    24931    tbl_bit_ticket_detalle_accion 
   TABLE DATA           �   COPY nova_ticket.tbl_bit_ticket_detalle_accion (id_bit_ticket_detalle_accion, id_bit_ticket, id_cat_usuario, id_cat_ticket_accion, antes, despues, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion, campo) FROM stdin;
    nova_ticket          vince    false    325   
j      :          0    24915 !   tbl_bit_ticket_detalle_comentario 
   TABLE DATA           �   COPY nova_ticket.tbl_bit_ticket_detalle_comentario (id_bit_ticket_detalle_comentario, id_bit_ticket, id_cat_usuario, descripcion, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    321   �l      <          0    24924    tbl_bit_ticket_seguimiento 
   TABLE DATA           �   COPY nova_ticket.tbl_bit_ticket_seguimiento (id_bit_ticket_seguimiento, id_bit_ticket, id_cat_usuario, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    323   �l      @          0    25063    tbl_bit_ticket_vista 
   TABLE DATA           �   COPY nova_ticket.tbl_bit_ticket_vista (id_bit_ticket_vista, id_bit_ticket, id_cat_usuario, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    327   .m      ,          0    24841    tbl_cat_ticket_accion 
   TABLE DATA           �   COPY nova_ticket.tbl_cat_ticket_accion (id_cat_ticket_accion, nombre, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    307   &n      6          0    24899    tbl_cat_ticket_canal 
   TABLE DATA           �   COPY nova_ticket.tbl_cat_ticket_canal (id_cat_ticket_canal, nombre, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    317   �n      0          0    24855    tbl_cat_ticket_estado_proceso 
   TABLE DATA           �   COPY nova_ticket.tbl_cat_ticket_estado_proceso (id_cat_ticket_estado_proceso, nombre, descripcion, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    311   o      2          0    24862     tbl_cat_ticket_estado_resolucion 
   TABLE DATA           �   COPY nova_ticket.tbl_cat_ticket_estado_resolucion (id_cat_ticket_estado_resolucion, nombre, descripcion, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    313   p      4          0    24892    tbl_cat_ticket_prioridad 
   TABLE DATA           �   COPY nova_ticket.tbl_cat_ticket_prioridad (id_cat_ticket_prioridad, nombre, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    315   �p      .          0    24848    tbl_cat_ticket_tipo 
   TABLE DATA           �   COPY nova_ticket.tbl_cat_ticket_tipo (id_cat_ticket_tipo, nombre, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    nova_ticket          vince    false    309   ?q      }          0    26516    tbl_bit_version_detalle 
   TABLE DATA           �   COPY nova_version.tbl_bit_version_detalle (id_bit_version_detalle, id_cat_version, id_cat_version_categoria, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    nova_version          vince    false    388   �q                0    26526    tbl_bit_version_detalle_resumen 
   TABLE DATA           �   COPY nova_version.tbl_bit_version_detalle_resumen (id_bit_version_detalle_resumen, id_bit_version_detalle, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    nova_version          vince    false    390   �q      y          0    26498    tbl_cat_version 
   TABLE DATA           �   COPY nova_version.tbl_cat_version (id_cat_version, nombe, nivel_uno, nivel_dos, nivel_tres, fecha_lanzamiento, es_produccion, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    nova_version          vince    false    384   �q      {          0    26508    tbl_cat_version_categoria 
   TABLE DATA           �   COPY nova_version.tbl_cat_version_categoria (id_cat_version_categoria, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    nova_version          vince    false    386   �q      �          0    23879    tbl_cat_aplicativo 
   TABLE DATA           �   COPY usuarios.tbl_cat_aplicativo (id_cat_aplicativo, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    229   r      �          0    23915    tbl_cat_departamento 
   TABLE DATA           �   COPY usuarios.tbl_cat_departamento (id_cat_departamento, id_cat_empresa, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    236   �r      �          0    23906    tbl_cat_empresa 
   TABLE DATA           �   COPY usuarios.tbl_cat_empresa (id_cat_empresa, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    234   �t      �          0    23924    tbl_cat_equipo 
   TABLE DATA           �   COPY usuarios.tbl_cat_equipo (id_cat_equipo, id_cat_departamento, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    238   -u      �          0    23977    tbl_cat_permiso_accion 
   TABLE DATA           �   COPY usuarios.tbl_cat_permiso_accion (id_cat_permiso_accion, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    250   �w      �          0    23952    tbl_cat_permiso_grupo 
   TABLE DATA           �   COPY usuarios.tbl_cat_permiso_grupo (id_cat_permiso_grupo, id_cat_permiso_nivel, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    244   Lx      �          0    23941    tbl_cat_permiso_nivel 
   TABLE DATA           �   COPY usuarios.tbl_cat_permiso_nivel (id_cat_permiso_nivel, nombre, descripcion, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    242   �x      �          0    23888    tbl_cat_puesto 
   TABLE DATA           �   COPY usuarios.tbl_cat_puesto (id_cat_puesto, nombre, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    231   �x      �          0    23896    tbl_cat_usuario 
   TABLE DATA           &  COPY usuarios.tbl_cat_usuario (id_cat_usuario, nombre, id_ad, correo, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por, user_principal_name, apagado_automatico, telefono, codigo_pais, id_cat_usuario_dominio, tipo_usuario, id_cat_usuario_categoria, username) FROM stdin;
    usuarios          vince    false    232   Jz      D          0    25729    tbl_cat_usuario_categoria 
   TABLE DATA           �   COPY usuarios.tbl_cat_usuario_categoria (id_cat_usuario_categoria, nombre, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    usuarios          vince    false    331   d�      F          0    25736    tbl_cat_usuario_dominio 
   TABLE DATA           �   COPY usuarios.tbl_cat_usuario_dominio (id_cat_usuario_dominio, nombre, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion, responsable) FROM stdin;
    usuarios          vince    false    333   ��      $          0    24638 +   tbl_det_departamento_asignacion_responsable 
   TABLE DATA           �   COPY usuarios.tbl_det_departamento_asignacion_responsable (id_det_departamento_asignacion_responsable, id_cat_departamento, id_cat_usuario, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    usuarios          vince    false    299   ��      "          0    24632 &   tbl_det_empresa_asignacion_responsable 
   TABLE DATA           �   COPY usuarios.tbl_det_empresa_asignacion_responsable (id_det_empresa_asignacion_responsable, id_cat_empresa, id_cat_usuario, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    usuarios          vince    false    297   2�      &          0    24644 %   tbl_det_equipo_asignacion_responsable 
   TABLE DATA           �   COPY usuarios.tbl_det_equipo_asignacion_responsable (id_det_equipo_asignacion_responsable, id_cat_equipo, id_cat_usuario, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    usuarios          vince    false    301   ��      �          0    23969 #   tbl_det_grupo_asignacion_aplicativo 
   TABLE DATA           �   COPY usuarios.tbl_det_grupo_asignacion_aplicativo (id_det_grupo_asignacion_aplicativo, id_cat_permiso_grupo, id_cat_aplicativo, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    248   Ԓ      �          0    23988    tbl_det_nivel_asignacion_accion 
   TABLE DATA           �   COPY usuarios.tbl_det_nivel_asignacion_accion (id_det_accion_asignacion_nivel, id_cat_permiso_accion, id_cat_permiso_nivel, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    252   �      *          0    24808     tbl_det_puesto_asignacion_equipo 
   TABLE DATA           �   COPY usuarios.tbl_det_puesto_asignacion_equipo (id_det_puesto_asignacion_equipo, id_cat_puesto, id_cat_equipo, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
    usuarios          vince    false    305   T�      �          0    23933 !   tbl_det_usuario_asignacion_equipo 
   TABLE DATA           �   COPY usuarios.tbl_det_usuario_asignacion_equipo (id_det_usuario_asignacion_equipo, id_cat_equipo, id_cat_usuario, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    240   �      �          0    23961 "   tbl_det_usuario_asignacion_permiso 
   TABLE DATA           �   COPY usuarios.tbl_det_usuario_asignacion_permiso (id_det_usuario_asignacion_permiso, id_cat_usuario, id_cat_permiso_grupo, estado, fecha_creacion, fecha_actualizacion, creado_por, actualizado_por) FROM stdin;
    usuarios          vince    false    246   Ε      �          0    24204 !   tbl_det_usuario_asignacion_puesto 
   TABLE DATA           �   COPY usuarios.tbl_det_usuario_asignacion_puesto (id_det_usuario_asignacion_puesto, id_cat_usuario, estado, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion, predeterminado, id_det_puesto_asignacion_equipo) FROM stdin;
    usuarios          vince    false    254   -�      �           0    0 <   tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq    SEQUENCE SET     s   SELECT pg_catalog.setval('compras_cuenta.tbl_cat_cuenta_clasificacion_id_cat_cuenta_clasificacion_seq', 37, true);
          compras_cuenta          vince    false    369            �           0    0     tbl_cat_cuenta_id_cat_cuenta_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('compras_cuenta.tbl_cat_cuenta_id_cat_cuenta_seq', 104, true);
          compras_cuenta          vince    false    381            �           0    0 2   tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq    SEQUENCE SET     r   SELECT pg_catalog.setval('compras_cuenta_bancaria.tbl_cat_cuenta_bancaria_id_cat_cuenta_bancaria_seq', 1, false);
          compras_cuenta_bancaria          vince    false    357            �           0    0     tbl_cat_moneda_id_cat_moneda_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('compras_orden_compra.tbl_cat_moneda_id_cat_moneda_seq', 1, false);
          compras_orden_compra          vince    false    351            �           0    0 :   tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq    SEQUENCE SET     w   SELECT pg_catalog.setval('compras_orden_compra.tbl_cat_orden_compra_estado_id_cat_orden_compra_estado_seq', 1, false);
          compras_orden_compra          vince    false    359            �           0    0 ,   tbl_cat_orden_compra_id_cat_orden_compra_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('compras_orden_compra.tbl_cat_orden_compra_id_cat_orden_compra_seq', 1, false);
          compras_orden_compra          vince    false    365            �           0    0 ?   tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq    SEQUENCE SET     |   SELECT pg_catalog.setval('compras_orden_compra.tbl_cat_orden_compra_metodo_p_id_cat_orden_compra_metodo_pa_seq', 1, false);
          compras_orden_compra          vince    false    355            �           0    0 ?   tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq    SEQUENCE SET     |   SELECT pg_catalog.setval('compras_orden_compra.tbl_cat_orden_compra_tipo_cuo_id_cat_orden_compra_tipo_cuot_seq', 1, false);
          compras_orden_compra          vince    false    353            �           0    0 ,   tbl_det_orden_compra_id_det_orden_compra_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('compras_orden_compra.tbl_det_orden_compra_id_det_orden_compra_seq', 1, false);
          compras_orden_compra          vince    false    367            �           0    0 8   tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq    SEQUENCE SET     t   SELECT pg_catalog.setval('compras_presupuesto.tbl_bit_presupuesto_ajuste_id_bit_presupuesto_ajuste_seq', 39, true);
          compras_presupuesto          vince    false    379            �           0    0 8   tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq    SEQUENCE SET     t   SELECT pg_catalog.setval('compras_presupuesto.tbl_cat_presupuesto_estado_id_cat_presupuesto_estado_seq', 12, true);
          compras_presupuesto          vince    false    361            �           0    0 *   tbl_cat_presupuesto_id_cat_presupuesto_seq    SEQUENCE SET     f   SELECT pg_catalog.setval('compras_presupuesto.tbl_cat_presupuesto_id_cat_presupuesto_seq', 79, true);
          compras_presupuesto          vince    false    363            �           0    0 *   tbl_det_presupuesto_id_det_presupuesto_seq    SEQUENCE SET     g   SELECT pg_catalog.setval('compras_presupuesto.tbl_det_presupuesto_id_det_presupuesto_seq', 403, true);
          compras_presupuesto          vince    false    371            �           0    0 8   tbl_cat_producto_categoria_id_cat_producto_categoria_seq    SEQUENCE SET     q   SELECT pg_catalog.setval('compras_producto.tbl_cat_producto_categoria_id_cat_producto_categoria_seq', 1, false);
          compras_producto          vince    false    340            �           0    0 ?   tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq    SEQUENCE SET     x   SELECT pg_catalog.setval('compras_producto.tbl_cat_producto_unidad_medid_id_cat_producto_unidad_medida_seq', 1, false);
          compras_producto          vince    false    342            �           0    0 0   tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('compras_proveedor.tbl_cat_proveedor_giro_id_cat_proveedor_giro_seq', 2, true);
          compras_proveedor          vince    false    334            �           0    0 &   tbl_cat_proveedor_id_cat_proveedor_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('compras_proveedor.tbl_cat_proveedor_id_cat_proveedor_seq', 3, true);
          compras_proveedor          vince    false    338            �           0    0 0   tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('compras_proveedor.tbl_cat_proveedor_tipo_id_cat_proveedor_tipo_seq', 2, true);
          compras_proveedor          vince    false    336            �           0    0 4   tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq    SEQUENCE SET     n   SELECT pg_catalog.setval('compras_recepcion.tbl_cat_recepcion_estado_id_cat_recepcion_estado_seq', 1, false);
          compras_recepcion          vince    false    373            �           0    0 &   tbl_cat_recepcion_id_cat_recepcion_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('compras_recepcion.tbl_cat_recepcion_id_cat_recepcion_seq', 1, false);
          compras_recepcion          vince    false    375            �           0    0 &   tbl_det_recepcion_id_det_recepcion_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('compras_recepcion.tbl_det_recepcion_id_det_recepcion_seq', 1, false);
          compras_recepcion          vince    false    377            �           0    0 4   tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq    SEQUENCE SET     n   SELECT pg_catalog.setval('compras_solicitud.tbl_cat_solicitud_estado_id_cat_solicitud_estado_seq', 1, false);
          compras_solicitud          vince    false    345            �           0    0 &   tbl_cat_solicitud_id_cat_solicitud_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('compras_solicitud.tbl_cat_solicitud_id_cat_solicitud_seq', 1, false);
          compras_solicitud          vince    false    347            �           0    0 &   tbl_det_solicitud_id_det_solicitud_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('compras_solicitud.tbl_det_solicitud_id_det_solicitud_seq', 1, false);
          compras_solicitud          vince    false    349            �           0    0 "   tbl_bit_marcaje_id_bit_marcaje_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('general.tbl_bit_marcaje_id_bit_marcaje_seq', 66, true);
          general          vince    false    393            �           0    0 4   tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq    SEQUENCE SET     e   SELECT pg_catalog.setval('general.tbl_bit_reporte_consulta_id_bit_reporte_consulta_seq', 841, true);
          general          vince    false    294            �           0    0    tbl_cat_mes_id_cat_mes_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('general.tbl_cat_mes_id_cat_mes_seq', 13, true);
          general          vince    false    302            �           0    0 :   tbl_bit_aplicacion_registro_id_bit_aplicacion_registro_seq    SEQUENCE SET     s   SELECT pg_catalog.setval('nova_aplicacion.tbl_bit_aplicacion_registro_id_bit_aplicacion_registro_seq', 808, true);
          nova_aplicacion          vince    false    257            �           0    0 (   tbl_cat_aplicacion_id_cat_aplicacion_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('nova_aplicacion.tbl_cat_aplicacion_id_cat_aplicacion_seq', 67, true);
          nova_aplicacion          vince    false    255            �           0    0 ?   tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq    SEQUENCE SET     y   SELECT pg_catalog.setval('nova_dispositivo.tbl_bit_dispositivo_diagnosti_id_bit_dispositivo_diagnostic_seq', 604, true);
          nova_dispositivo          vince    false    328            �           0    0 *   tbl_cat_dispositivo_id_cat_dispositivo_seq    SEQUENCE SET     c   SELECT pg_catalog.setval('nova_dispositivo.tbl_cat_dispositivo_id_cat_dispositivo_seq', 21, true);
          nova_dispositivo          vince    false    284            �           0    0    tbl_cat_falta_id_cat_falta_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('nova_falta.tbl_cat_falta_id_cat_falta_seq', 1, false);
       
   nova_falta          vince    false    263            �           0    0 .   tbl_cat_justificacion_id_cat_justificacion_seq    SEQUENCE SET     a   SELECT pg_catalog.setval('nova_falta.tbl_cat_justificacion_id_cat_justificacion_seq', 1, false);
       
   nova_falta          vince    false    259            �           0    0 (   tbl_cat_tipo_falta_id_cat_tipo_falta_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('nova_falta.tbl_cat_tipo_falta_id_cat_tipo_falta_seq', 1, false);
       
   nova_falta          vince    false    261            �           0    0 /   tbl_bit_horario_marcaje_id_cat_tipo_horario_seq    SEQUENCE SET     d   SELECT pg_catalog.setval('nova_horario.tbl_bit_horario_marcaje_id_cat_tipo_horario_seq', 22, true);
          nova_horario          vince    false    292            �           0    0 0   tbl_cat_horario_accion_id_cat_horario_accion_seq    SEQUENCE SET     e   SELECT pg_catalog.setval('nova_horario.tbl_cat_horario_accion_id_cat_horario_accion_seq', 1, false);
          nova_horario          vince    false    286            �           0    0 ?   tbl_det_horario_asignacion_di_id_det_horario_asignacion_dia_seq    SEQUENCE SET     t   SELECT pg_catalog.setval('nova_horario.tbl_det_horario_asignacion_di_id_det_horario_asignacion_dia_seq', 1, false);
          nova_horario          vince    false    290            �           0    0 ?   tbl_det_horario_asignacion_us_id_det_horario_asignacion_usu_seq    SEQUENCE SET     t   SELECT pg_catalog.setval('nova_horario.tbl_det_horario_asignacion_us_id_det_horario_asignacion_usu_seq', 1, false);
          nova_horario          vince    false    288            �           0    0 <   tbl_cat_sla_campo_evaluacion_id_cat_sla_campo_evaluacion_seq    SEQUENCE SET     q   SELECT pg_catalog.setval('nova_metrica.tbl_cat_sla_campo_evaluacion_id_cat_sla_campo_evaluacion_seq', 1, false);
          nova_metrica          vince    false    266            �           0    0 (   tbl_cat_sla_estado_id_cat_sla_estado_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('nova_metrica.tbl_cat_sla_estado_id_cat_sla_estado_seq', 1, false);
          nova_metrica          vince    false    268            �           0    0    tbl_cat_sla_id_cat_sla_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('nova_metrica.tbl_cat_sla_id_cat_sla_seq', 1, false);
          nova_metrica          vince    false    270            �           0    0 .   tbl_bit_tarea_comentario_id_cat_comentario_seq    SEQUENCE SET     i   SELECT pg_catalog.setval('nova_proceso_tarea.tbl_bit_tarea_comentario_id_cat_comentario_seq', 40, true);
          nova_proceso_tarea          vince    false    280            �           0    0 0   tbl_bit_tarea_registro_id_bit_tarea_registro_seq    SEQUENCE SET     l   SELECT pg_catalog.setval('nova_proceso_tarea.tbl_bit_tarea_registro_id_bit_tarea_registro_seq', 315, true);
          nova_proceso_tarea          vince    false    278            �           0    0 "   tbl_cat_proceso_id_cat_proceso_seq    SEQUENCE SET     \   SELECT pg_catalog.setval('nova_proceso_tarea.tbl_cat_proceso_id_cat_proceso_seq', 7, true);
          nova_proceso_tarea          vince    false    272            �           0    0 ,   tbl_cat_tarea_estado_id_cat_tarea_estado_seq    SEQUENCE SET     f   SELECT pg_catalog.setval('nova_proceso_tarea.tbl_cat_tarea_estado_id_cat_tarea_estado_seq', 4, true);
          nova_proceso_tarea          vince    false    276            �           0    0    tbl_cat_tarea_id_cat_tarea_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('nova_proceso_tarea.tbl_cat_tarea_id_cat_tarea_seq', 13, true);
          nova_proceso_tarea          vince    false    274            �           0    0 ?   tbl_det_tarea_asignacion_pues_id_det_tarea_asignacion_usuar_seq    SEQUENCE SET     y   SELECT pg_catalog.setval('nova_proceso_tarea.tbl_det_tarea_asignacion_pues_id_det_tarea_asignacion_usuar_seq', 1, true);
          nova_proceso_tarea          vince    false    282            �           0    0 >   tbl_bit_ticket_detalle_accion_id_bit_ticket_detalle_accion_seq    SEQUENCE SET     r   SELECT pg_catalog.setval('nova_ticket.tbl_bit_ticket_detalle_accion_id_bit_ticket_detalle_accion_seq', 1, false);
          nova_ticket          vince    false    324            �           0    0 ?   tbl_bit_ticket_detalle_coment_id_bit_ticket_detalle_comenta_seq    SEQUENCE SET     s   SELECT pg_catalog.setval('nova_ticket.tbl_bit_ticket_detalle_coment_id_bit_ticket_detalle_comenta_seq', 1, false);
          nova_ticket          vince    false    320            �           0    0     tbl_bit_ticket_id_bit_ticket_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('nova_ticket.tbl_bit_ticket_id_bit_ticket_seq', 556, true);
          nova_ticket          vince    false    318            �           0    0 8   tbl_bit_ticket_seguimiento_id_bit_ticket_seguimiento_seq    SEQUENCE SET     l   SELECT pg_catalog.setval('nova_ticket.tbl_bit_ticket_seguimiento_id_bit_ticket_seguimiento_seq', 1, false);
          nova_ticket          vince    false    322            �           0    0 ,   tbl_bit_ticket_vista_id_bit_ticket_vista_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('nova_ticket.tbl_bit_ticket_vista_id_bit_ticket_vista_seq', 1, false);
          nova_ticket          vince    false    326            �           0    0 .   tbl_cat_ticket_accion_id_cat_ticket_accion_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('nova_ticket.tbl_cat_ticket_accion_id_cat_ticket_accion_seq', 1, false);
          nova_ticket          vince    false    306            �           0    0 ,   tbl_cat_ticket_canal_id_cat_ticket_canal_seq    SEQUENCE SET     `   SELECT pg_catalog.setval('nova_ticket.tbl_cat_ticket_canal_id_cat_ticket_canal_seq', 1, false);
          nova_ticket          vince    false    316            �           0    0 >   tbl_cat_ticket_estado_proceso_id_cat_ticket_estado_proceso_seq    SEQUENCE SET     q   SELECT pg_catalog.setval('nova_ticket.tbl_cat_ticket_estado_proceso_id_cat_ticket_estado_proceso_seq', 2, true);
          nova_ticket          vince    false    310            �           0    0 ?   tbl_cat_ticket_estado_resoluc_id_cat_ticket_estado_resoluci_seq    SEQUENCE SET     s   SELECT pg_catalog.setval('nova_ticket.tbl_cat_ticket_estado_resoluc_id_cat_ticket_estado_resoluci_seq', 1, false);
          nova_ticket          vince    false    312            �           0    0 4   tbl_cat_ticket_prioridad_id_cat_ticket_prioridad_seq    SEQUENCE SET     h   SELECT pg_catalog.setval('nova_ticket.tbl_cat_ticket_prioridad_id_cat_ticket_prioridad_seq', 1, false);
          nova_ticket          vince    false    314            �           0    0 *   tbl_cat_ticket_tipo_id_cat_ticket_tipo_seq    SEQUENCE SET     ^   SELECT pg_catalog.setval('nova_ticket.tbl_cat_ticket_tipo_id_cat_ticket_tipo_seq', 1, false);
          nova_ticket          vince    false    308            �           0    0 2   tbl_bit_version_detalle_id_bit_version_detalle_seq    SEQUENCE SET     g   SELECT pg_catalog.setval('nova_version.tbl_bit_version_detalle_id_bit_version_detalle_seq', 1, false);
          nova_version          vince    false    387            �           0    0 ?   tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq    SEQUENCE SET     t   SELECT pg_catalog.setval('nova_version.tbl_bit_version_detalle_resum_id_bit_version_detalle_resume_seq', 1, false);
          nova_version          vince    false    389            �           0    0 6   tbl_cat_version_categoria_id_cat_version_categoria_seq    SEQUENCE SET     k   SELECT pg_catalog.setval('nova_version.tbl_cat_version_categoria_id_cat_version_categoria_seq', 1, false);
          nova_version          vince    false    385            �           0    0 "   tbl_cat_version_id_cat_version_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('nova_version.tbl_cat_version_id_cat_version_seq', 1, false);
          nova_version          vince    false    383            �           0    0 (   tbl_cat_aplicativo_id_cat_aplicativo_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('usuarios.tbl_cat_aplicativo_id_cat_aplicativo_seq', 1, false);
          usuarios          vince    false    228            �           0    0 ,   tbl_cat_departamento_id_cat_departamento_seq    SEQUENCE SET     \   SELECT pg_catalog.setval('usuarios.tbl_cat_departamento_id_cat_departamento_seq', 1, true);
          usuarios          vince    false    235            �           0    0 "   tbl_cat_empresa_id_cat_empresa_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('usuarios.tbl_cat_empresa_id_cat_empresa_seq', 1, false);
          usuarios          vince    false    233                        0    0     tbl_cat_equipo_id_cat_equipo_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('usuarios.tbl_cat_equipo_id_cat_equipo_seq', 2, true);
          usuarios          vince    false    237                       0    0 0   tbl_cat_permiso_accion_id_cat_permiso_accion_seq    SEQUENCE SET     a   SELECT pg_catalog.setval('usuarios.tbl_cat_permiso_accion_id_cat_permiso_accion_seq', 1, false);
          usuarios          vince    false    249                       0    0 .   tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('usuarios.tbl_cat_permiso_grupo_id_cat_permiso_grupo_seq', 1, false);
          usuarios          vince    false    243                       0    0 .   tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('usuarios.tbl_cat_permiso_nivel_id_cat_permiso_nivel_seq', 1, false);
          usuarios          vince    false    241                       0    0     tbl_cat_puesto_id_cat_puesto_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('usuarios.tbl_cat_puesto_id_cat_puesto_seq', 1, false);
          usuarios          vince    false    230                       0    0 ?   tbl_cat_usuario_categoria_id_cat_ticket_solicitante_categor_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_cat_usuario_categoria_id_cat_ticket_solicitante_categor_seq', 1, false);
          usuarios          vince    false    330                       0    0 1   tbl_cat_usuario_dominio_id_cat_ticket_dominio_seq    SEQUENCE SET     b   SELECT pg_catalog.setval('usuarios.tbl_cat_usuario_dominio_id_cat_ticket_dominio_seq', 1, false);
          usuarios          vince    false    332                       0    0 "   tbl_cat_usuario_id_cat_usuario_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('usuarios.tbl_cat_usuario_id_cat_usuario_seq', 88, true);
          usuarios          vince    false    391                       0    0 ?   tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_departamento_asignaci_id_det_departamento_asignacio_seq', 1, false);
          usuarios          vince    false    298            	           0    0 ?   tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_empresa_asignacion_re_id_det_empresa_asignacion_res_seq', 1, false);
          usuarios          vince    false    296            
           0    0 ?   tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_equipo_asignacion_res_id_det_equipo_asignacion_resp_seq', 1, false);
          usuarios          vince    false    300                       0    0 ?   tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_grupo_asignacion_apli_id_det_grupo_asignacion_aplic_seq', 1, false);
          usuarios          vince    false    247                       0    0 ?   tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_nivel_asignacion_acci_id_det_accion_asignacion_nive_seq', 1, false);
          usuarios          vince    false    251                       0    0 ?   tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_puesto_asignacion_equ_id_det_puesto_asignacion_equi_seq', 1, false);
          usuarios          vince    false    304                       0    0 ?   tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_usuario_asignacion_equipo_id_det_usuario_asignacion_seq', 1, false);
          usuarios          vince    false    239                       0    0 ?   tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_usuario_asignacion_pe_id_det_usuario_asignacion_per_seq', 1, false);
          usuarios          vince    false    245                       0    0 ?   tbl_det_usuario_asignacion_pu_id_det_usuario_asignacion_pue_seq    SEQUENCE SET     p   SELECT pg_catalog.setval('usuarios.tbl_det_usuario_asignacion_pu_id_det_usuario_asignacion_pue_seq', 1, false);
          usuarios          vince    false    253            �           2606    26155 >   tbl_cat_cuenta_clasificacion tbl_cat_cuenta_clasificacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta_clasificacion
    ADD CONSTRAINT tbl_cat_cuenta_clasificacion_pkey PRIMARY KEY (id_cat_cuenta_clasificacion);
 p   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta_clasificacion DROP CONSTRAINT tbl_cat_cuenta_clasificacion_pkey;
       compras_cuenta            vince    false    370            �           2606    26390 "   tbl_cat_cuenta tbl_cat_cuenta_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta
    ADD CONSTRAINT tbl_cat_cuenta_pkey PRIMARY KEY (id_cat_cuenta);
 T   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta DROP CONSTRAINT tbl_cat_cuenta_pkey;
       compras_cuenta            vince    false    382            �           2606    26100 4   tbl_cat_cuenta_bancaria tbl_cat_cuenta_bancaria_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_cuenta_bancaria.tbl_cat_cuenta_bancaria
    ADD CONSTRAINT tbl_cat_cuenta_bancaria_pkey PRIMARY KEY (id_cat_cuenta_bancaria);
 o   ALTER TABLE ONLY compras_cuenta_bancaria.tbl_cat_cuenta_bancaria DROP CONSTRAINT tbl_cat_cuenta_bancaria_pkey;
       compras_cuenta_bancaria            vince    false    358            �           2606    26076 "   tbl_cat_moneda tbl_cat_moneda_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY compras_orden_compra.tbl_cat_moneda
    ADD CONSTRAINT tbl_cat_moneda_pkey PRIMARY KEY (id_cat_moneda);
 Z   ALTER TABLE ONLY compras_orden_compra.tbl_cat_moneda DROP CONSTRAINT tbl_cat_moneda_pkey;
       compras_orden_compra            vince    false    352            �           2606    26108 <   tbl_cat_orden_compra_estado tbl_cat_orden_compra_estado_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_estado
    ADD CONSTRAINT tbl_cat_orden_compra_estado_pkey PRIMARY KEY (id_cat_orden_compra_estado);
 t   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_estado DROP CONSTRAINT tbl_cat_orden_compra_estado_pkey;
       compras_orden_compra            vince    false    360            �           2606    26092 F   tbl_cat_orden_compra_metodo_pago tbl_cat_orden_compra_metodo_pago_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_metodo_pago
    ADD CONSTRAINT tbl_cat_orden_compra_metodo_pago_pkey PRIMARY KEY (id_cat_orden_compra_metodo_pago);
 ~   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_metodo_pago DROP CONSTRAINT tbl_cat_orden_compra_metodo_pago_pkey;
       compras_orden_compra            vince    false    356            �           2606    26139 .   tbl_cat_orden_compra tbl_cat_orden_compra_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT tbl_cat_orden_compra_pkey PRIMARY KEY (id_cat_orden_compra);
 f   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT tbl_cat_orden_compra_pkey;
       compras_orden_compra            vince    false    366            �           2606    26084 D   tbl_cat_orden_compra_tipo_cuota tbl_cat_orden_compra_tipo_cuota_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_tipo_cuota
    ADD CONSTRAINT tbl_cat_orden_compra_tipo_cuota_pkey PRIMARY KEY (id_cat_orden_compra_tipo_cuota);
 |   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra_tipo_cuota DROP CONSTRAINT tbl_cat_orden_compra_tipo_cuota_pkey;
       compras_orden_compra            vince    false    354            �           2606    26147 .   tbl_det_orden_compra tbl_det_orden_compra_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_det_orden_compra
    ADD CONSTRAINT tbl_det_orden_compra_pkey PRIMARY KEY (id_det_orden_compra);
 f   ALTER TABLE ONLY compras_orden_compra.tbl_det_orden_compra DROP CONSTRAINT tbl_det_orden_compra_pkey;
       compras_orden_compra            vince    false    368            �           2606    26216 :   tbl_bit_presupuesto_ajuste tbl_bit_presupuesto_ajuste_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste
    ADD CONSTRAINT tbl_bit_presupuesto_ajuste_pkey PRIMARY KEY (id_bit_presupuesto_ajuste);
 q   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste DROP CONSTRAINT tbl_bit_presupuesto_ajuste_pkey;
       compras_presupuesto            vince    false    380            �           2606    26119 :   tbl_cat_presupuesto_estado tbl_cat_presupuesto_estado_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto_estado
    ADD CONSTRAINT tbl_cat_presupuesto_estado_pkey PRIMARY KEY (id_cat_presupuesto_estado);
 q   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto_estado DROP CONSTRAINT tbl_cat_presupuesto_estado_pkey;
       compras_presupuesto            vince    false    362            �           2606    26129 ,   tbl_cat_presupuesto tbl_cat_presupuesto_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto
    ADD CONSTRAINT tbl_cat_presupuesto_pkey PRIMARY KEY (id_cat_presupuesto);
 c   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto DROP CONSTRAINT tbl_cat_presupuesto_pkey;
       compras_presupuesto            vince    false    364            �           2606    26176 ,   tbl_det_presupuesto tbl_det_presupuesto_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_det_presupuesto
    ADD CONSTRAINT tbl_det_presupuesto_pkey PRIMARY KEY (id_det_presupuesto);
 c   ALTER TABLE ONLY compras_presupuesto.tbl_det_presupuesto DROP CONSTRAINT tbl_det_presupuesto_pkey;
       compras_presupuesto            vince    false    372            �           2606    26024 :   tbl_cat_producto_categoria tbl_cat_producto_categoria_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_producto.tbl_cat_producto_categoria
    ADD CONSTRAINT tbl_cat_producto_categoria_pkey PRIMARY KEY (id_cat_producto_categoria);
 n   ALTER TABLE ONLY compras_producto.tbl_cat_producto_categoria DROP CONSTRAINT tbl_cat_producto_categoria_pkey;
       compras_producto            vince    false    341            �           2606    26280 $   tbl_cat_producto tbl_cat_producto_pk 
   CONSTRAINT     y   ALTER TABLE ONLY compras_producto.tbl_cat_producto
    ADD CONSTRAINT tbl_cat_producto_pk PRIMARY KEY (id_cat_producto);
 X   ALTER TABLE ONLY compras_producto.tbl_cat_producto DROP CONSTRAINT tbl_cat_producto_pk;
       compras_producto            vince    false    344            �           2606    26032 B   tbl_cat_producto_unidad_medida tbl_cat_producto_unidad_medida_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_producto.tbl_cat_producto_unidad_medida
    ADD CONSTRAINT tbl_cat_producto_unidad_medida_pkey PRIMARY KEY (id_cat_producto_unidad_medida);
 v   ALTER TABLE ONLY compras_producto.tbl_cat_producto_unidad_medida DROP CONSTRAINT tbl_cat_producto_unidad_medida_pkey;
       compras_producto            vince    false    343            �           2606    25998 2   tbl_cat_proveedor_giro tbl_cat_proveedor_giro_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor_giro
    ADD CONSTRAINT tbl_cat_proveedor_giro_pkey PRIMARY KEY (id_cat_proveedor_giro);
 g   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor_giro DROP CONSTRAINT tbl_cat_proveedor_giro_pkey;
       compras_proveedor            vince    false    335            �           2606    26016 (   tbl_cat_proveedor tbl_cat_proveedor_pkey 
   CONSTRAINT        ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor
    ADD CONSTRAINT tbl_cat_proveedor_pkey PRIMARY KEY (id_cat_proveedor);
 ]   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor DROP CONSTRAINT tbl_cat_proveedor_pkey;
       compras_proveedor            vince    false    339            �           2606    26006 2   tbl_cat_proveedor_tipo tbl_cat_proveedor_tipo_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor_tipo
    ADD CONSTRAINT tbl_cat_proveedor_tipo_pkey PRIMARY KEY (id_cat_proveedor_tipo);
 g   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor_tipo DROP CONSTRAINT tbl_cat_proveedor_tipo_pkey;
       compras_proveedor            vince    false    337            �           2606    26186 6   tbl_cat_recepcion_estado tbl_cat_recepcion_estado_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion_estado
    ADD CONSTRAINT tbl_cat_recepcion_estado_pkey PRIMARY KEY (id_cat_recepcion_estado);
 k   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion_estado DROP CONSTRAINT tbl_cat_recepcion_estado_pkey;
       compras_recepcion            vince    false    374            �           2606    26196 (   tbl_cat_recepcion tbl_cat_recepcion_pkey 
   CONSTRAINT        ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion
    ADD CONSTRAINT tbl_cat_recepcion_pkey PRIMARY KEY (id_cat_recepcion);
 ]   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion DROP CONSTRAINT tbl_cat_recepcion_pkey;
       compras_recepcion            vince    false    376            �           2606    26206 (   tbl_det_recepcion tbl_det_recepcion_pkey 
   CONSTRAINT        ALTER TABLE ONLY compras_recepcion.tbl_det_recepcion
    ADD CONSTRAINT tbl_det_recepcion_pkey PRIMARY KEY (id_det_recepcion);
 ]   ALTER TABLE ONLY compras_recepcion.tbl_det_recepcion DROP CONSTRAINT tbl_det_recepcion_pkey;
       compras_recepcion            vince    false    378            �           2606    26048 6   tbl_cat_solicitud_estado tbl_cat_solicitud_estado_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud_estado
    ADD CONSTRAINT tbl_cat_solicitud_estado_pkey PRIMARY KEY (id_cat_solicitud_estado);
 k   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud_estado DROP CONSTRAINT tbl_cat_solicitud_estado_pkey;
       compras_solicitud            vince    false    346            �           2606    26058 (   tbl_cat_solicitud tbl_cat_solicitud_pkey 
   CONSTRAINT        ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud
    ADD CONSTRAINT tbl_cat_solicitud_pkey PRIMARY KEY (id_cat_solicitud);
 ]   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud DROP CONSTRAINT tbl_cat_solicitud_pkey;
       compras_solicitud            vince    false    348            �           2606    26066 (   tbl_det_solicitud tbl_det_solicitud_pkey 
   CONSTRAINT        ALTER TABLE ONLY compras_solicitud.tbl_det_solicitud
    ADD CONSTRAINT tbl_det_solicitud_pkey PRIMARY KEY (id_det_solicitud);
 ]   ALTER TABLE ONLY compras_solicitud.tbl_det_solicitud DROP CONSTRAINT tbl_det_solicitud_pkey;
       compras_solicitud            vince    false    350            �           2606    26968 $   tbl_bit_marcaje tbl_bit_marcaje_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY general.tbl_bit_marcaje
    ADD CONSTRAINT tbl_bit_marcaje_pkey PRIMARY KEY (id_bit_marcaje);
 O   ALTER TABLE ONLY general.tbl_bit_marcaje DROP CONSTRAINT tbl_bit_marcaje_pkey;
       general            vince    false    392            f           2606    24598 4   tbl_bit_reporte_consulta tbl_bit_reporte_consulta_pk 
   CONSTRAINT     �   ALTER TABLE ONLY general.tbl_bit_reporte_consulta
    ADD CONSTRAINT tbl_bit_reporte_consulta_pk PRIMARY KEY (id_bit_reporte_consulta);
 _   ALTER TABLE ONLY general.tbl_bit_reporte_consulta DROP CONSTRAINT tbl_bit_reporte_consulta_pk;
       general            vince    false    295            r           2606    24770    tbl_cat_mes tbl_cat_mes_pk 
   CONSTRAINT     a   ALTER TABLE ONLY general.tbl_cat_mes
    ADD CONSTRAINT tbl_cat_mes_pk PRIMARY KEY (id_cat_mes);
 E   ALTER TABLE ONLY general.tbl_cat_mes DROP CONSTRAINT tbl_cat_mes_pk;
       general            vince    false    303            1           2606    24275 <   tbl_bit_aplicacion_registro tbl_bit_aplicacion_registro_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_aplicacion.tbl_bit_aplicacion_registro
    ADD CONSTRAINT tbl_bit_aplicacion_registro_pkey PRIMARY KEY (id_bit_aplicacion_registro);
 o   ALTER TABLE ONLY nova_aplicacion.tbl_bit_aplicacion_registro DROP CONSTRAINT tbl_bit_aplicacion_registro_pkey;
       nova_aplicacion            vince    false    258            .           2606    24268 *   tbl_cat_aplicacion tbl_cat_aplicacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_aplicacion.tbl_cat_aplicacion
    ADD CONSTRAINT tbl_cat_aplicacion_pkey PRIMARY KEY (id_cat_aplicacion);
 ]   ALTER TABLE ONLY nova_aplicacion.tbl_cat_aplicacion DROP CONSTRAINT tbl_cat_aplicacion_pkey;
       nova_aplicacion            vince    false    256            �           2606    25504 B   tbl_bit_dispositivo_diagnostico tbl_bit_dispositivo_diagnostico_pk 
   CONSTRAINT     �   ALTER TABLE ONLY nova_dispositivo.tbl_bit_dispositivo_diagnostico
    ADD CONSTRAINT tbl_bit_dispositivo_diagnostico_pk PRIMARY KEY (id_bit_dispositivo_diagnostico);
 v   ALTER TABLE ONLY nova_dispositivo.tbl_bit_dispositivo_diagnostico DROP CONSTRAINT tbl_bit_dispositivo_diagnostico_pk;
       nova_dispositivo            vince    false    329            W           2606    24470 ,   tbl_cat_dispositivo tbl_cat_dispositivo_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_dispositivo.tbl_cat_dispositivo
    ADD CONSTRAINT tbl_cat_dispositivo_pkey PRIMARY KEY (id_cat_dispositivo);
 `   ALTER TABLE ONLY nova_dispositivo.tbl_cat_dispositivo DROP CONSTRAINT tbl_cat_dispositivo_pkey;
       nova_dispositivo            vince    false    285            9           2606    24299     tbl_cat_falta tbl_cat_falta_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY nova_falta.tbl_cat_falta
    ADD CONSTRAINT tbl_cat_falta_pkey PRIMARY KEY (id_cat_falta);
 N   ALTER TABLE ONLY nova_falta.tbl_cat_falta DROP CONSTRAINT tbl_cat_falta_pkey;
    
   nova_falta            vince    false    264            3           2606    24284 0   tbl_cat_justificacion tbl_cat_justificacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_falta.tbl_cat_justificacion
    ADD CONSTRAINT tbl_cat_justificacion_pkey PRIMARY KEY (id_cat_justificacion);
 ^   ALTER TABLE ONLY nova_falta.tbl_cat_justificacion DROP CONSTRAINT tbl_cat_justificacion_pkey;
    
   nova_falta            vince    false    260            5           2606    24291 *   tbl_cat_tipo_falta tbl_cat_tipo_falta_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY nova_falta.tbl_cat_tipo_falta
    ADD CONSTRAINT tbl_cat_tipo_falta_pkey PRIMARY KEY (id_cat_tipo_falta);
 X   ALTER TABLE ONLY nova_falta.tbl_cat_tipo_falta DROP CONSTRAINT tbl_cat_tipo_falta_pkey;
    
   nova_falta            vince    false    262            c           2606    24506 4   tbl_bit_horario_marcaje tbl_bit_horario_marcaje_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_horario.tbl_bit_horario_marcaje
    ADD CONSTRAINT tbl_bit_horario_marcaje_pkey PRIMARY KEY (id_cat_tipo_horario);
 d   ALTER TABLE ONLY nova_horario.tbl_bit_horario_marcaje DROP CONSTRAINT tbl_bit_horario_marcaje_pkey;
       nova_horario            vince    false    293            Y           2606    24481 2   tbl_cat_horario_accion tbl_cat_horario_accion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_horario.tbl_cat_horario_accion
    ADD CONSTRAINT tbl_cat_horario_accion_pkey PRIMARY KEY (id_cat_horario_accion);
 b   ALTER TABLE ONLY nova_horario.tbl_cat_horario_accion DROP CONSTRAINT tbl_cat_horario_accion_pkey;
       nova_horario            vince    false    287            _           2606    24499 B   tbl_det_horario_asignacion_dia tbl_det_horario_asignacion_dia_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_dia
    ADD CONSTRAINT tbl_det_horario_asignacion_dia_pkey PRIMARY KEY (id_det_horario_asignacion_dia);
 r   ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_dia DROP CONSTRAINT tbl_det_horario_asignacion_dia_pkey;
       nova_horario            vince    false    291            [           2606    24488 J   tbl_det_horario_asignacion_usuario tbl_det_horario_asignacion_usuario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_usuario
    ADD CONSTRAINT tbl_det_horario_asignacion_usuario_pkey PRIMARY KEY (id_det_horario_asignacion_usuario);
 z   ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_usuario DROP CONSTRAINT tbl_det_horario_asignacion_usuario_pkey;
       nova_horario            vince    false    289            ;           2606    24306 <   tbl_cat_sla_campo_categoria tbl_cat_sla_campo_categoria_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_metrica.tbl_cat_sla_campo_categoria
    ADD CONSTRAINT tbl_cat_sla_campo_categoria_pkey PRIMARY KEY (id_cat_sla_campo_categoria);
 l   ALTER TABLE ONLY nova_metrica.tbl_cat_sla_campo_categoria DROP CONSTRAINT tbl_cat_sla_campo_categoria_pkey;
       nova_metrica            vince    false    265            >           2606    24313 >   tbl_cat_sla_campo_evaluacion tbl_cat_sla_campo_evaluacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_metrica.tbl_cat_sla_campo_evaluacion
    ADD CONSTRAINT tbl_cat_sla_campo_evaluacion_pkey PRIMARY KEY (id_cat_sla_campo_evaluacion);
 n   ALTER TABLE ONLY nova_metrica.tbl_cat_sla_campo_evaluacion DROP CONSTRAINT tbl_cat_sla_campo_evaluacion_pkey;
       nova_metrica            vince    false    267            @           2606    24322 *   tbl_cat_sla_estado tbl_cat_sla_estado_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY nova_metrica.tbl_cat_sla_estado
    ADD CONSTRAINT tbl_cat_sla_estado_pkey PRIMARY KEY (id_cat_sla_estado);
 Z   ALTER TABLE ONLY nova_metrica.tbl_cat_sla_estado DROP CONSTRAINT tbl_cat_sla_estado_pkey;
       nova_metrica            vince    false    269            C           2606    24331    tbl_cat_sla tbl_cat_sla_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY nova_metrica.tbl_cat_sla
    ADD CONSTRAINT tbl_cat_sla_pkey PRIMARY KEY (id_cat_sla);
 L   ALTER TABLE ONLY nova_metrica.tbl_cat_sla DROP CONSTRAINT tbl_cat_sla_pkey;
       nova_metrica            vince    false    271            R           2606    24374 6   tbl_bit_tarea_comentario tbl_bit_tarea_comentario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_comentario
    ADD CONSTRAINT tbl_bit_tarea_comentario_pkey PRIMARY KEY (id_cat_comentario);
 l   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_comentario DROP CONSTRAINT tbl_bit_tarea_comentario_pkey;
       nova_proceso_tarea            vince    false    281            O           2606    24365 2   tbl_bit_tarea_registro tbl_bit_tarea_registro_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_registro
    ADD CONSTRAINT tbl_bit_tarea_registro_pkey PRIMARY KEY (id_bit_tarea_registro);
 h   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_registro DROP CONSTRAINT tbl_bit_tarea_registro_pkey;
       nova_proceso_tarea            vince    false    279            E           2606    24340 $   tbl_cat_proceso tbl_cat_proceso_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_proceso
    ADD CONSTRAINT tbl_cat_proceso_pkey PRIMARY KEY (id_cat_proceso);
 Z   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_proceso DROP CONSTRAINT tbl_cat_proceso_pkey;
       nova_proceso_tarea            vince    false    273            K           2606    24358 .   tbl_cat_tarea_estado tbl_cat_tarea_estado_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_tarea_estado
    ADD CONSTRAINT tbl_cat_tarea_estado_pkey PRIMARY KEY (id_cat_tarea_estado);
 d   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_tarea_estado DROP CONSTRAINT tbl_cat_tarea_estado_pkey;
       nova_proceso_tarea            vince    false    277            I           2606    24349     tbl_cat_tarea tbl_cat_tarea_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_tarea
    ADD CONSTRAINT tbl_cat_tarea_pkey PRIMARY KEY (id_cat_tarea);
 V   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_tarea DROP CONSTRAINT tbl_cat_tarea_pkey;
       nova_proceso_tarea            vince    false    275            U           2606    24381 F   tbl_det_proceso_asignacion_puesto tbl_det_tarea_asignacion_puesto_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_det_proceso_asignacion_puesto
    ADD CONSTRAINT tbl_det_tarea_asignacion_puesto_pkey PRIMARY KEY (id_det_proceso_asignacion_puesto);
 |   ALTER TABLE ONLY nova_proceso_tarea.tbl_det_proceso_asignacion_puesto DROP CONSTRAINT tbl_det_tarea_asignacion_puesto_pkey;
       nova_proceso_tarea            vince    false    283            �           2606    24938 @   tbl_bit_ticket_detalle_accion tbl_bit_ticket_detalle_accion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_accion
    ADD CONSTRAINT tbl_bit_ticket_detalle_accion_pkey PRIMARY KEY (id_bit_ticket_detalle_accion);
 o   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_accion DROP CONSTRAINT tbl_bit_ticket_detalle_accion_pkey;
       nova_ticket            vince    false    325            �           2606    24922 H   tbl_bit_ticket_detalle_comentario tbl_bit_ticket_detalle_comentario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_comentario
    ADD CONSTRAINT tbl_bit_ticket_detalle_comentario_pkey PRIMARY KEY (id_bit_ticket_detalle_comentario);
 w   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_comentario DROP CONSTRAINT tbl_bit_ticket_detalle_comentario_pkey;
       nova_ticket            vince    false    321            �           2606    24913 "   tbl_bit_ticket tbl_bit_ticket_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket
    ADD CONSTRAINT tbl_bit_ticket_pkey PRIMARY KEY (id_bit_ticket);
 Q   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket DROP CONSTRAINT tbl_bit_ticket_pkey;
       nova_ticket            vince    false    319            �           2606    24929 :   tbl_bit_ticket_seguimiento tbl_bit_ticket_seguimiento_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_seguimiento
    ADD CONSTRAINT tbl_bit_ticket_seguimiento_pkey PRIMARY KEY (id_bit_ticket_seguimiento);
 i   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_seguimiento DROP CONSTRAINT tbl_bit_ticket_seguimiento_pkey;
       nova_ticket            vince    false    323            �           2606    25069 ,   tbl_bit_ticket_vista tbl_bit_ticket_vista_pk 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_vista
    ADD CONSTRAINT tbl_bit_ticket_vista_pk PRIMARY KEY (id_bit_ticket_vista);
 [   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_vista DROP CONSTRAINT tbl_bit_ticket_vista_pk;
       nova_ticket            vince    false    327            w           2606    24846 0   tbl_cat_ticket_accion tbl_cat_ticket_accion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_accion
    ADD CONSTRAINT tbl_cat_ticket_accion_pkey PRIMARY KEY (id_cat_ticket_accion);
 _   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_accion DROP CONSTRAINT tbl_cat_ticket_accion_pkey;
       nova_ticket            vince    false    307            �           2606    24904 .   tbl_cat_ticket_canal tbl_cat_ticket_canal_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_canal
    ADD CONSTRAINT tbl_cat_ticket_canal_pkey PRIMARY KEY (id_cat_ticket_canal);
 ]   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_canal DROP CONSTRAINT tbl_cat_ticket_canal_pkey;
       nova_ticket            vince    false    317            {           2606    24860 @   tbl_cat_ticket_estado_proceso tbl_cat_ticket_estado_proceso_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_estado_proceso
    ADD CONSTRAINT tbl_cat_ticket_estado_proceso_pkey PRIMARY KEY (id_cat_ticket_estado_proceso);
 o   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_estado_proceso DROP CONSTRAINT tbl_cat_ticket_estado_proceso_pkey;
       nova_ticket            vince    false    311            }           2606    24867 F   tbl_cat_ticket_estado_resolucion tbl_cat_ticket_estado_resolucion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_estado_resolucion
    ADD CONSTRAINT tbl_cat_ticket_estado_resolucion_pkey PRIMARY KEY (id_cat_ticket_estado_resolucion);
 u   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_estado_resolucion DROP CONSTRAINT tbl_cat_ticket_estado_resolucion_pkey;
       nova_ticket            vince    false    313                       2606    24897 6   tbl_cat_ticket_prioridad tbl_cat_ticket_prioridad_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_prioridad
    ADD CONSTRAINT tbl_cat_ticket_prioridad_pkey PRIMARY KEY (id_cat_ticket_prioridad);
 e   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_prioridad DROP CONSTRAINT tbl_cat_ticket_prioridad_pkey;
       nova_ticket            vince    false    315            y           2606    24853 ,   tbl_cat_ticket_tipo tbl_cat_ticket_tipo_pkey 
   CONSTRAINT        ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_tipo
    ADD CONSTRAINT tbl_cat_ticket_tipo_pkey PRIMARY KEY (id_cat_ticket_tipo);
 [   ALTER TABLE ONLY nova_ticket.tbl_cat_ticket_tipo DROP CONSTRAINT tbl_cat_ticket_tipo_pkey;
       nova_ticket            vince    false    309            �           2606    26524 4   tbl_bit_version_detalle tbl_bit_version_detalle_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle
    ADD CONSTRAINT tbl_bit_version_detalle_pkey PRIMARY KEY (id_bit_version_detalle);
 d   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle DROP CONSTRAINT tbl_bit_version_detalle_pkey;
       nova_version            vince    false    388            �           2606    26534 D   tbl_bit_version_detalle_resumen tbl_bit_version_detalle_resumen_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle_resumen
    ADD CONSTRAINT tbl_bit_version_detalle_resumen_pkey PRIMARY KEY (id_bit_version_detalle_resumen);
 t   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle_resumen DROP CONSTRAINT tbl_bit_version_detalle_resumen_pkey;
       nova_version            vince    false    390            �           2606    26514 8   tbl_cat_version_categoria tbl_cat_version_categoria_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY nova_version.tbl_cat_version_categoria
    ADD CONSTRAINT tbl_cat_version_categoria_pkey PRIMARY KEY (id_cat_version_categoria);
 h   ALTER TABLE ONLY nova_version.tbl_cat_version_categoria DROP CONSTRAINT tbl_cat_version_categoria_pkey;
       nova_version            vince    false    386            �           2606    26506 $   tbl_cat_version tbl_cat_version_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY nova_version.tbl_cat_version
    ADD CONSTRAINT tbl_cat_version_pkey PRIMARY KEY (id_cat_version);
 T   ALTER TABLE ONLY nova_version.tbl_cat_version DROP CONSTRAINT tbl_cat_version_pkey;
       nova_version            vince    false    384            u           2606    24814 ,   tbl_det_puesto_asignacion_equipo newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_puesto_asignacion_equipo
    ADD CONSTRAINT newtable_pk PRIMARY KEY (id_det_puesto_asignacion_equipo);
 X   ALTER TABLE ONLY usuarios.tbl_det_puesto_asignacion_equipo DROP CONSTRAINT newtable_pk;
       usuarios            vince    false    305                       2606    23886 *   tbl_cat_aplicativo tbl_cat_aplicativo_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY usuarios.tbl_cat_aplicativo
    ADD CONSTRAINT tbl_cat_aplicativo_pkey PRIMARY KEY (id_cat_aplicativo);
 V   ALTER TABLE ONLY usuarios.tbl_cat_aplicativo DROP CONSTRAINT tbl_cat_aplicativo_pkey;
       usuarios            vince    false    229                       2606    23922 .   tbl_cat_departamento tbl_cat_departamento_pkey 
   CONSTRAINT        ALTER TABLE ONLY usuarios.tbl_cat_departamento
    ADD CONSTRAINT tbl_cat_departamento_pkey PRIMARY KEY (id_cat_departamento);
 Z   ALTER TABLE ONLY usuarios.tbl_cat_departamento DROP CONSTRAINT tbl_cat_departamento_pkey;
       usuarios            vince    false    236                       2606    23913 $   tbl_cat_empresa tbl_cat_empresa_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY usuarios.tbl_cat_empresa
    ADD CONSTRAINT tbl_cat_empresa_pkey PRIMARY KEY (id_cat_empresa);
 P   ALTER TABLE ONLY usuarios.tbl_cat_empresa DROP CONSTRAINT tbl_cat_empresa_pkey;
       usuarios            vince    false    234                       2606    23931 "   tbl_cat_equipo tbl_cat_equipo_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY usuarios.tbl_cat_equipo
    ADD CONSTRAINT tbl_cat_equipo_pkey PRIMARY KEY (id_cat_equipo);
 N   ALTER TABLE ONLY usuarios.tbl_cat_equipo DROP CONSTRAINT tbl_cat_equipo_pkey;
       usuarios            vince    false    238            &           2606    23986 2   tbl_cat_permiso_accion tbl_cat_permiso_accion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_permiso_accion
    ADD CONSTRAINT tbl_cat_permiso_accion_pkey PRIMARY KEY (id_cat_permiso_accion);
 ^   ALTER TABLE ONLY usuarios.tbl_cat_permiso_accion DROP CONSTRAINT tbl_cat_permiso_accion_pkey;
       usuarios            vince    false    250                       2606    23959 0   tbl_cat_permiso_grupo tbl_cat_permiso_grupo_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_permiso_grupo
    ADD CONSTRAINT tbl_cat_permiso_grupo_pkey PRIMARY KEY (id_cat_permiso_grupo);
 \   ALTER TABLE ONLY usuarios.tbl_cat_permiso_grupo DROP CONSTRAINT tbl_cat_permiso_grupo_pkey;
       usuarios            vince    false    244                       2606    23950 0   tbl_cat_permiso_nivel tbl_cat_permiso_nivel_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_permiso_nivel
    ADD CONSTRAINT tbl_cat_permiso_nivel_pkey PRIMARY KEY (id_cat_permiso_nivel);
 \   ALTER TABLE ONLY usuarios.tbl_cat_permiso_nivel DROP CONSTRAINT tbl_cat_permiso_nivel_pkey;
       usuarios            vince    false    242            	           2606    23895 "   tbl_cat_puesto tbl_cat_puesto_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY usuarios.tbl_cat_puesto
    ADD CONSTRAINT tbl_cat_puesto_pkey PRIMARY KEY (id_cat_puesto);
 N   ALTER TABLE ONLY usuarios.tbl_cat_puesto DROP CONSTRAINT tbl_cat_puesto_pkey;
       usuarios            vince    false    231            �           2606    25741 5   tbl_cat_usuario_dominio tbl_cat_ticket_dominio_pkey_1 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_usuario_dominio
    ADD CONSTRAINT tbl_cat_ticket_dominio_pkey_1 PRIMARY KEY (id_cat_usuario_dominio);
 a   ALTER TABLE ONLY usuarios.tbl_cat_usuario_dominio DROP CONSTRAINT tbl_cat_ticket_dominio_pkey_1;
       usuarios            vince    false    333            �           2606    25734 C   tbl_cat_usuario_categoria tbl_cat_ticket_solicitante_categoria_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_usuario_categoria
    ADD CONSTRAINT tbl_cat_ticket_solicitante_categoria_pkey PRIMARY KEY (id_cat_usuario_categoria);
 o   ALTER TABLE ONLY usuarios.tbl_cat_usuario_categoria DROP CONSTRAINT tbl_cat_ticket_solicitante_categoria_pkey;
       usuarios            vince    false    331                       2606    23904 $   tbl_cat_usuario tbl_cat_usuario_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY usuarios.tbl_cat_usuario
    ADD CONSTRAINT tbl_cat_usuario_pkey PRIMARY KEY (id_cat_usuario);
 P   ALTER TABLE ONLY usuarios.tbl_cat_usuario DROP CONSTRAINT tbl_cat_usuario_pkey;
       usuarios            vince    false    232            l           2606    24681 Z   tbl_det_departamento_asignacion_responsable tbl_det_departamento_asignacion_responsable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_departamento_asignacion_responsable
    ADD CONSTRAINT tbl_det_departamento_asignacion_responsable_pk PRIMARY KEY (id_det_departamento_asignacion_responsable);
 �   ALTER TABLE ONLY usuarios.tbl_det_departamento_asignacion_responsable DROP CONSTRAINT tbl_det_departamento_asignacion_responsable_pk;
       usuarios            vince    false    299            i           2606    24683 P   tbl_det_empresa_asignacion_responsable tbl_det_empresa_asignacion_responsable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_empresa_asignacion_responsable
    ADD CONSTRAINT tbl_det_empresa_asignacion_responsable_pk PRIMARY KEY (id_det_empresa_asignacion_responsable);
 |   ALTER TABLE ONLY usuarios.tbl_det_empresa_asignacion_responsable DROP CONSTRAINT tbl_det_empresa_asignacion_responsable_pk;
       usuarios            vince    false    297            o           2606    24687 N   tbl_det_equipo_asignacion_responsable tbl_det_equipo_asignacion_responsable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_equipo_asignacion_responsable
    ADD CONSTRAINT tbl_det_equipo_asignacion_responsable_pk PRIMARY KEY (id_det_equipo_asignacion_responsable);
 z   ALTER TABLE ONLY usuarios.tbl_det_equipo_asignacion_responsable DROP CONSTRAINT tbl_det_equipo_asignacion_responsable_pk;
       usuarios            vince    false    301            $           2606    23975 L   tbl_det_grupo_asignacion_aplicativo tbl_det_grupo_asignacion_aplicativo_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_grupo_asignacion_aplicativo
    ADD CONSTRAINT tbl_det_grupo_asignacion_aplicativo_pkey PRIMARY KEY (id_det_grupo_asignacion_aplicativo);
 x   ALTER TABLE ONLY usuarios.tbl_det_grupo_asignacion_aplicativo DROP CONSTRAINT tbl_det_grupo_asignacion_aplicativo_pkey;
       usuarios            vince    false    248            *           2606    23994 D   tbl_det_nivel_asignacion_accion tbl_det_nivel_asignacion_accion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_nivel_asignacion_accion
    ADD CONSTRAINT tbl_det_nivel_asignacion_accion_pkey PRIMARY KEY (id_det_accion_asignacion_nivel);
 p   ALTER TABLE ONLY usuarios.tbl_det_nivel_asignacion_accion DROP CONSTRAINT tbl_det_nivel_asignacion_accion_pkey;
       usuarios            vince    false    252                       2606    23939 H   tbl_det_usuario_asignacion_equipo tbl_det_usuario_asignacion_equipo_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_equipo
    ADD CONSTRAINT tbl_det_usuario_asignacion_equipo_pkey PRIMARY KEY (id_det_usuario_asignacion_equipo);
 t   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_equipo DROP CONSTRAINT tbl_det_usuario_asignacion_equipo_pkey;
       usuarios            vince    false    240                        2606    23967 J   tbl_det_usuario_asignacion_permiso tbl_det_usuario_asignacion_permiso_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_permiso
    ADD CONSTRAINT tbl_det_usuario_asignacion_permiso_pkey PRIMARY KEY (id_det_usuario_asignacion_permiso);
 v   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_permiso DROP CONSTRAINT tbl_det_usuario_asignacion_permiso_pkey;
       usuarios            vince    false    246            ,           2606    24209 H   tbl_det_usuario_asignacion_puesto tbl_det_usuario_asignacion_puesto_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_puesto
    ADD CONSTRAINT tbl_det_usuario_asignacion_puesto_pkey PRIMARY KEY (id_det_usuario_asignacion_puesto);
 t   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_puesto DROP CONSTRAINT tbl_det_usuario_asignacion_puesto_pkey;
       usuarios            vince    false    254            �           1259    26391 3   fk_tbl_cat_cuenta_tbl_cat_cuenta_clasificacion1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_cuenta_tbl_cat_cuenta_clasificacion1_idx ON compras_cuenta.tbl_cat_cuenta USING btree (id_cat_cuenta_clasificacion);
 O   DROP INDEX compras_cuenta.fk_tbl_cat_cuenta_tbl_cat_cuenta_clasificacion1_idx;
       compras_cuenta            vince    false    382            �           1259    26226 !   fk_tbl_cat_oc_tbl_cat_moneda1_idx    INDEX     y   CREATE INDEX fk_tbl_cat_oc_tbl_cat_moneda1_idx ON compras_orden_compra.tbl_cat_orden_compra USING btree (id_cat_moneda);
 C   DROP INDEX compras_orden_compra.fk_tbl_cat_oc_tbl_cat_moneda1_idx;
       compras_orden_compra            vince    false    366            �           1259    26229 4   fk_tbl_cat_orden_compra_tbl_cat_cuenta_bancaria1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_orden_compra_tbl_cat_cuenta_bancaria1_idx ON compras_orden_compra.tbl_cat_orden_compra USING btree (id_cat_cuenta_bancaria);
 V   DROP INDEX compras_orden_compra.fk_tbl_cat_orden_compra_tbl_cat_cuenta_bancaria1_idx;
       compras_orden_compra            vince    false    366            �           1259    26230 8   fk_tbl_cat_orden_compra_tbl_cat_orden_compra_estado1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_orden_compra_tbl_cat_orden_compra_estado1_idx ON compras_orden_compra.tbl_cat_orden_compra USING btree (id_cat_orden_compra_estado);
 Z   DROP INDEX compras_orden_compra.fk_tbl_cat_orden_compra_tbl_cat_orden_compra_estado1_idx;
       compras_orden_compra            vince    false    366            �           1259    26228 =   fk_tbl_cat_orden_compra_tbl_cat_orden_compra_metodo_pago1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_orden_compra_tbl_cat_orden_compra_metodo_pago1_idx ON compras_orden_compra.tbl_cat_orden_compra USING btree (id_cat_orden_compra_metodo_pago);
 _   DROP INDEX compras_orden_compra.fk_tbl_cat_orden_compra_tbl_cat_orden_compra_metodo_pago1_idx;
       compras_orden_compra            vince    false    366            �           1259    26227 <   fk_tbl_cat_orden_compra_tbl_cat_orden_compra_tipo_cuota1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_orden_compra_tbl_cat_orden_compra_tipo_cuota1_idx ON compras_orden_compra.tbl_cat_orden_compra USING btree (id_cat_orden_compra_tipo_cuota);
 ^   DROP INDEX compras_orden_compra.fk_tbl_cat_orden_compra_tbl_cat_orden_compra_tipo_cuota1_idx;
       compras_orden_compra            vince    false    366            �           1259    26231 0   fk_tbl_cat_orden_compra_tbl_cat_presupuesto1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_orden_compra_tbl_cat_presupuesto1_idx ON compras_orden_compra.tbl_cat_orden_compra USING btree (id_cat_presupuesto);
 R   DROP INDEX compras_orden_compra.fk_tbl_cat_orden_compra_tbl_cat_presupuesto1_idx;
       compras_orden_compra            vince    false    366            �           1259    26232 .   fk_tbl_cat_orden_compra_tbl_cat_proveedor1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_orden_compra_tbl_cat_proveedor1_idx ON compras_orden_compra.tbl_cat_orden_compra USING btree (id_cat_proveedor);
 P   DROP INDEX compras_orden_compra.fk_tbl_cat_orden_compra_tbl_cat_proveedor1_idx;
       compras_orden_compra            vince    false    366            �           1259    26233    fk_tbl_det_oc_tbl_cat_oc1_idx    INDEX     {   CREATE INDEX fk_tbl_det_oc_tbl_cat_oc1_idx ON compras_orden_compra.tbl_det_orden_compra USING btree (id_cat_orden_compra);
 ?   DROP INDEX compras_orden_compra.fk_tbl_det_oc_tbl_cat_oc1_idx;
       compras_orden_compra            vince    false    368            �           1259    26242 1   fk_tbl_bit_presupuesto_ajuste_tbl_cat_cuenta1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_presupuesto_ajuste_tbl_cat_cuenta1_idx ON compras_presupuesto.tbl_bit_presupuesto_ajuste USING btree (cuenta_abono);
 R   DROP INDEX compras_presupuesto.fk_tbl_bit_presupuesto_ajuste_tbl_cat_cuenta1_idx;
       compras_presupuesto            vince    false    380            �           1259    26243 1   fk_tbl_bit_presupuesto_ajuste_tbl_cat_cuenta2_idx    INDEX     �   CREATE INDEX fk_tbl_bit_presupuesto_ajuste_tbl_cat_cuenta2_idx ON compras_presupuesto.tbl_bit_presupuesto_ajuste USING btree (cuenta_cargo);
 R   DROP INDEX compras_presupuesto.fk_tbl_bit_presupuesto_ajuste_tbl_cat_cuenta2_idx;
       compras_presupuesto            vince    false    380            �           1259    26241 6   fk_tbl_bit_presupuesto_ajuste_tbl_det_presupuesto1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_presupuesto_ajuste_tbl_det_presupuesto1_idx ON compras_presupuesto.tbl_bit_presupuesto_ajuste USING btree (id_det_presupuesto);
 W   DROP INDEX compras_presupuesto.fk_tbl_bit_presupuesto_ajuste_tbl_det_presupuesto1_idx;
       compras_presupuesto            vince    false    380            �           1259    26225 6   fk_tbl_cat_presupuesto_tbl_cat_presupuesto_estado1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_presupuesto_tbl_cat_presupuesto_estado1_idx ON compras_presupuesto.tbl_cat_presupuesto USING btree (id_cat_presupuesto_estado);
 W   DROP INDEX compras_presupuesto.fk_tbl_cat_presupuesto_tbl_cat_presupuesto_estado1_idx;
       compras_presupuesto            vince    false    364            �           1259    26236 *   fk_tbl_det_presupuesto_tbl_cat_cuenta1_idx    INDEX     �   CREATE INDEX fk_tbl_det_presupuesto_tbl_cat_cuenta1_idx ON compras_presupuesto.tbl_det_presupuesto USING btree (id_cat_cuenta);
 K   DROP INDEX compras_presupuesto.fk_tbl_det_presupuesto_tbl_cat_cuenta1_idx;
       compras_presupuesto            vince    false    372            �           1259    26235 /   fk_tbl_det_presupuesto_tbl_cat_presupuesto1_idx    INDEX     �   CREATE INDEX fk_tbl_det_presupuesto_tbl_cat_presupuesto1_idx ON compras_presupuesto.tbl_det_presupuesto USING btree (id_cat_presupuesto);
 P   DROP INDEX compras_presupuesto.fk_tbl_det_presupuesto_tbl_cat_presupuesto1_idx;
       compras_presupuesto            vince    false    372            �           1259    26567 *   tbl_cat_presupuesto_id_cat_presupuesto_idx    INDEX     �   CREATE INDEX tbl_cat_presupuesto_id_cat_presupuesto_idx ON compras_presupuesto.tbl_cat_presupuesto USING btree (id_cat_presupuesto);
 K   DROP INDEX compras_presupuesto.tbl_cat_presupuesto_id_cat_presupuesto_idx;
       compras_presupuesto            vince    false    364            �           1259    26219 3   fk_tbl_cat_producto_tbl_cat_producto_categoria1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_producto_tbl_cat_producto_categoria1_idx ON compras_producto.tbl_cat_producto USING btree (id_cat_producto_categoria);
 Q   DROP INDEX compras_producto.fk_tbl_cat_producto_tbl_cat_producto_categoria1_idx;
       compras_producto            vince    false    344            �           1259    26221 7   fk_tbl_cat_producto_tbl_cat_producto_unidad_medida1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_producto_tbl_cat_producto_unidad_medida1_idx ON compras_producto.tbl_cat_producto USING btree (id_cat_producto_unidad_medida);
 U   DROP INDEX compras_producto.fk_tbl_cat_producto_tbl_cat_producto_unidad_medida1_idx;
       compras_producto            vince    false    344            �           1259    26220 *   fk_tbl_cat_producto_tbl_cat_proveedor1_idx    INDEX     }   CREATE INDEX fk_tbl_cat_producto_tbl_cat_proveedor1_idx ON compras_producto.tbl_cat_producto USING btree (id_cat_proveedor);
 H   DROP INDEX compras_producto.fk_tbl_cat_producto_tbl_cat_proveedor1_idx;
       compras_producto            vince    false    344            �           1259    26217 0   fk_tbl_cat_proveedor_tbl_cat_proveedor_giro1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_proveedor_tbl_cat_proveedor_giro1_idx ON compras_proveedor.tbl_cat_proveedor USING btree (id_cat_proveedor_giro);
 O   DROP INDEX compras_proveedor.fk_tbl_cat_proveedor_tbl_cat_proveedor_giro1_idx;
       compras_proveedor            vince    false    339            �           1259    26218 0   fk_tbl_cat_proveedor_tbl_cat_proveedor_tipo1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_proveedor_tbl_cat_proveedor_tipo1_idx ON compras_proveedor.tbl_cat_proveedor USING btree (id_cat_proveedor_tipo);
 O   DROP INDEX compras_proveedor.fk_tbl_cat_proveedor_tbl_cat_proveedor_tipo1_idx;
       compras_proveedor            vince    false    339            �           1259    26238 .   fk_tbl_cat_recepcion_tbl_cat_orden_compra1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_recepcion_tbl_cat_orden_compra1_idx ON compras_recepcion.tbl_cat_recepcion USING btree (id_cat_orden_compra);
 M   DROP INDEX compras_recepcion.fk_tbl_cat_recepcion_tbl_cat_orden_compra1_idx;
       compras_recepcion            vince    false    376            �           1259    26237 2   fk_tbl_cat_recepcion_tbl_cat_recepcion_estado1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_recepcion_tbl_cat_recepcion_estado1_idx ON compras_recepcion.tbl_cat_recepcion USING btree (id_cat_recepcion_estado);
 Q   DROP INDEX compras_recepcion.fk_tbl_cat_recepcion_tbl_cat_recepcion_estado1_idx;
       compras_recepcion            vince    false    376            �           1259    26240 *   fk_tbl_det_recepcion_tbl_cat_producto1_idx    INDEX     ~   CREATE INDEX fk_tbl_det_recepcion_tbl_cat_producto1_idx ON compras_recepcion.tbl_det_recepcion USING btree (id_cat_producto);
 I   DROP INDEX compras_recepcion.fk_tbl_det_recepcion_tbl_cat_producto1_idx;
       compras_recepcion            vince    false    378            �           1259    26239 +   fk_tbl_det_recepcion_tbl_cat_recepcion1_idx    INDEX     �   CREATE INDEX fk_tbl_det_recepcion_tbl_cat_recepcion1_idx ON compras_recepcion.tbl_det_recepcion USING btree (id_cat_recepcion);
 J   DROP INDEX compras_recepcion.fk_tbl_det_recepcion_tbl_cat_recepcion1_idx;
       compras_recepcion            vince    false    378            �           1259    26222 2   fk_tbl_cat_solicitud_tbl_cat_solicitud_estado1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_solicitud_tbl_cat_solicitud_estado1_idx ON compras_solicitud.tbl_cat_solicitud USING btree (id_cat_solicitud_estado);
 Q   DROP INDEX compras_solicitud.fk_tbl_cat_solicitud_tbl_cat_solicitud_estado1_idx;
       compras_solicitud            vince    false    348            �           1259    26224 *   fk_tbl_det_solicitud_tbl_cat_producto1_idx    INDEX     ~   CREATE INDEX fk_tbl_det_solicitud_tbl_cat_producto1_idx ON compras_solicitud.tbl_det_solicitud USING btree (id_cat_producto);
 I   DROP INDEX compras_solicitud.fk_tbl_det_solicitud_tbl_cat_producto1_idx;
       compras_solicitud            vince    false    350            �           1259    26223 +   fk_tbl_det_solicitud_tbl_cat_solicitud1_idx    INDEX     �   CREATE INDEX fk_tbl_det_solicitud_tbl_cat_solicitud1_idx ON compras_solicitud.tbl_det_solicitud USING btree (id_cat_solicitud);
 J   DROP INDEX compras_solicitud.fk_tbl_det_solicitud_tbl_cat_solicitud1_idx;
       compras_solicitud            vince    false    350            d           1259    24599 4   tbl_bit_reporte_consulta_id_bit_reporte_consulta_idx    INDEX     �   CREATE INDEX tbl_bit_reporte_consulta_id_bit_reporte_consulta_idx ON general.tbl_bit_reporte_consulta USING btree (id_bit_reporte_consulta);
 I   DROP INDEX general.tbl_bit_reporte_consulta_id_bit_reporte_consulta_idx;
       general            vince    false    295            p           1259    24771    tbl_cat_mes_id_cat_mes_idx    INDEX     Y   CREATE INDEX tbl_cat_mes_id_cat_mes_idx ON general.tbl_cat_mes USING btree (id_cat_mes);
 /   DROP INDEX general.tbl_cat_mes_id_cat_mes_idx;
       general            vince    false    303            /           1259    24448 6   fk_tbl_bit_aplicacion_registro_tbl_cat_aplicacion1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_aplicacion_registro_tbl_cat_aplicacion1_idx ON nova_aplicacion.tbl_bit_aplicacion_registro USING btree (id_cat_aplicacion);
 S   DROP INDEX nova_aplicacion.fk_tbl_bit_aplicacion_registro_tbl_cat_aplicacion1_idx;
       nova_aplicacion            vince    false    258            6           1259    24449 +   fk_tbl_cat_falta_tbl_cat_justificacion1_idx    INDEX     y   CREATE INDEX fk_tbl_cat_falta_tbl_cat_justificacion1_idx ON nova_falta.tbl_cat_falta USING btree (id_cat_justificacion);
 C   DROP INDEX nova_falta.fk_tbl_cat_falta_tbl_cat_justificacion1_idx;
    
   nova_falta            vince    false    264            7           1259    24450 (   fk_tbl_cat_falta_tbl_cat_tipo_falta1_idx    INDEX     s   CREATE INDEX fk_tbl_cat_falta_tbl_cat_tipo_falta1_idx ON nova_falta.tbl_cat_falta USING btree (id_cat_tipo_falta);
 @   DROP INDEX nova_falta.fk_tbl_cat_falta_tbl_cat_tipo_falta1_idx;
    
   nova_falta            vince    false    264            `           1259    24507 3   fk_tbl_bit_horario_marcaje_tbl_cat_dispositivo1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_horario_marcaje_tbl_cat_dispositivo1_idx ON nova_horario.tbl_bit_horario_marcaje USING btree (id_cat_dispositivo);
 M   DROP INDEX nova_horario.fk_tbl_bit_horario_marcaje_tbl_cat_dispositivo1_idx;
       nova_horario            vince    false    293            a           1259    24508 6   fk_tbl_bit_horario_marcaje_tbl_cat_horario_accion1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_horario_marcaje_tbl_cat_horario_accion1_idx ON nova_horario.tbl_bit_horario_marcaje USING btree (id_cat_horario_accion);
 P   DROP INDEX nova_horario.fk_tbl_bit_horario_marcaje_tbl_cat_horario_accion1_idx;
       nova_horario            vince    false    293            \           1259    24509 ?   fk_tbl_det_horario_asignacion_dia_tbl_det_horario_asignacio_idx    INDEX     �   CREATE INDEX fk_tbl_det_horario_asignacion_dia_tbl_det_horario_asignacio_idx ON nova_horario.tbl_det_horario_asignacion_dia USING btree (id_det_horario_asignacion_usuario);
 Y   DROP INDEX nova_horario.fk_tbl_det_horario_asignacion_dia_tbl_det_horario_asignacio_idx;
       nova_horario            vince    false    291            ]           1259    24510 ?   fk_tbl_det_horario_asignacion_usuario_tbl_cat_horario_accio_idx    INDEX     �   CREATE INDEX fk_tbl_det_horario_asignacion_usuario_tbl_cat_horario_accio_idx ON nova_horario.tbl_det_horario_asignacion_dia USING btree (id_cat_horario_accion);
 Y   DROP INDEX nova_horario.fk_tbl_det_horario_asignacion_usuario_tbl_cat_horario_accio_idx;
       nova_horario            vince    false    291            <           1259    24452 ?   fk_tbl_cat_sla_campo_evaluacion_tbl_cat_sla_campo_categoria_idx    INDEX     �   CREATE INDEX fk_tbl_cat_sla_campo_evaluacion_tbl_cat_sla_campo_categoria_idx ON nova_metrica.tbl_cat_sla_campo_evaluacion USING btree (id_cat_sla_campo_categoria);
 Y   DROP INDEX nova_metrica.fk_tbl_cat_sla_campo_evaluacion_tbl_cat_sla_campo_categoria_idx;
       nova_metrica            vince    false    267            A           1259    24453 &   fk_tbl_cat_sla_tbl_cat_sla_estado1_idx    INDEX     q   CREATE INDEX fk_tbl_cat_sla_tbl_cat_sla_estado1_idx ON nova_metrica.tbl_cat_sla USING btree (id_cat_sla_estado);
 @   DROP INDEX nova_metrica.fk_tbl_cat_sla_tbl_cat_sla_estado1_idx;
       nova_metrica            vince    false    271            P           1259    24456 7   fk_tbl_bit_tarea_comentario_tbl_bit_tarea_registro1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_tarea_comentario_tbl_bit_tarea_registro1_idx ON nova_proceso_tarea.tbl_bit_tarea_comentario USING btree (id_bit_tarea_registro);
 W   DROP INDEX nova_proceso_tarea.fk_tbl_bit_tarea_comentario_tbl_bit_tarea_registro1_idx;
       nova_proceso_tarea            vince    false    281            L           1259    24455 ,   fk_tbl_bit_tarea_registro_tbl_cat_tarea1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_tarea_registro_tbl_cat_tarea1_idx ON nova_proceso_tarea.tbl_bit_tarea_registro USING btree (id_cat_tarea);
 L   DROP INDEX nova_proceso_tarea.fk_tbl_bit_tarea_registro_tbl_cat_tarea1_idx;
       nova_proceso_tarea            vince    false    279            M           1259    24454 3   fk_tbl_bit_tarea_registro_tbl_cat_tarea_estado1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_tarea_registro_tbl_cat_tarea_estado1_idx ON nova_proceso_tarea.tbl_bit_tarea_registro USING btree (id_cat_tarea_estado);
 S   DROP INDEX nova_proceso_tarea.fk_tbl_bit_tarea_registro_tbl_cat_tarea_estado1_idx;
       nova_proceso_tarea            vince    false    279            F           1259    24382 %   fk_tbl_cat_tarea_tbl_cat_proceso1_idx    INDEX     u   CREATE INDEX fk_tbl_cat_tarea_tbl_cat_proceso1_idx ON nova_proceso_tarea.tbl_cat_tarea USING btree (id_cat_proceso);
 E   DROP INDEX nova_proceso_tarea.fk_tbl_cat_tarea_tbl_cat_proceso1_idx;
       nova_proceso_tarea            vince    false    275            G           1259    24451 %   fk_tbl_cat_tarea_tbl_cat_proceso2_idx    INDEX     u   CREATE INDEX fk_tbl_cat_tarea_tbl_cat_proceso2_idx ON nova_proceso_tarea.tbl_cat_tarea USING btree (id_cat_proceso);
 E   DROP INDEX nova_proceso_tarea.fk_tbl_cat_tarea_tbl_cat_proceso2_idx;
       nova_proceso_tarea            vince    false    275            S           1259    25232 2   tbl_det_tarea_asignacion_puesto_id_cat_proceso_idx    INDEX     �   CREATE INDEX tbl_det_tarea_asignacion_puesto_id_cat_proceso_idx ON nova_proceso_tarea.tbl_det_proceso_asignacion_puesto USING btree (id_cat_proceso);
 R   DROP INDEX nova_proceso_tarea.tbl_det_tarea_asignacion_puesto_id_cat_proceso_idx;
       nova_proceso_tarea            vince    false    283            �           1259    24951 4   fk_tbl_bit_ticket_detalle_accion_tbl_bit_ticket1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_detalle_accion_tbl_bit_ticket1_idx ON nova_ticket.tbl_bit_ticket_detalle_accion USING btree (id_bit_ticket);
 M   DROP INDEX nova_ticket.fk_tbl_bit_ticket_detalle_accion_tbl_bit_ticket1_idx;
       nova_ticket            vince    false    325            �           1259    24950 :   fk_tbl_bit_ticket_detalle_accion_tbl_cat_ticket_accion_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_detalle_accion_tbl_cat_ticket_accion_idx ON nova_ticket.tbl_bit_ticket_detalle_accion USING btree (id_cat_ticket_accion);
 S   DROP INDEX nova_ticket.fk_tbl_bit_ticket_detalle_accion_tbl_cat_ticket_accion_idx;
       nova_ticket            vince    false    325            �           1259    24948 8   fk_tbl_bit_ticket_detalle_comentario_tbl_bit_ticket1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_detalle_comentario_tbl_bit_ticket1_idx ON nova_ticket.tbl_bit_ticket_detalle_comentario USING btree (id_bit_ticket);
 Q   DROP INDEX nova_ticket.fk_tbl_bit_ticket_detalle_comentario_tbl_bit_ticket1_idx;
       nova_ticket            vince    false    321            �           1259    24949 1   fk_tbl_bit_ticket_seguimiento_tbl_bit_ticket1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_seguimiento_tbl_bit_ticket1_idx ON nova_ticket.tbl_bit_ticket_seguimiento USING btree (id_bit_ticket);
 J   DROP INDEX nova_ticket.fk_tbl_bit_ticket_seguimiento_tbl_bit_ticket1_idx;
       nova_ticket            vince    false    323            �           1259    24946 +   fk_tbl_bit_ticket_tbl_cat_ticket_canal1_idx    INDEX     z   CREATE INDEX fk_tbl_bit_ticket_tbl_cat_ticket_canal1_idx ON nova_ticket.tbl_bit_ticket USING btree (id_cat_ticket_canal);
 D   DROP INDEX nova_ticket.fk_tbl_bit_ticket_tbl_cat_ticket_canal1_idx;
       nova_ticket            vince    false    319            �           1259    24942 4   fk_tbl_bit_ticket_tbl_cat_ticket_estado_proceso1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_tbl_cat_ticket_estado_proceso1_idx ON nova_ticket.tbl_bit_ticket USING btree (id_cat_ticket_estado_proceso);
 M   DROP INDEX nova_ticket.fk_tbl_bit_ticket_tbl_cat_ticket_estado_proceso1_idx;
       nova_ticket            vince    false    319            �           1259    24943 7   fk_tbl_bit_ticket_tbl_cat_ticket_estado_resolucion1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_tbl_cat_ticket_estado_resolucion1_idx ON nova_ticket.tbl_bit_ticket USING btree (id_cat_ticket_estado_resolucion);
 P   DROP INDEX nova_ticket.fk_tbl_bit_ticket_tbl_cat_ticket_estado_resolucion1_idx;
       nova_ticket            vince    false    319            �           1259    24945 /   fk_tbl_bit_ticket_tbl_cat_ticket_prioridad1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_tbl_cat_ticket_prioridad1_idx ON nova_ticket.tbl_bit_ticket USING btree (id_cat_ticket_prioridad);
 H   DROP INDEX nova_ticket.fk_tbl_bit_ticket_tbl_cat_ticket_prioridad1_idx;
       nova_ticket            vince    false    319            �           1259    24944 1   fk_tbl_bit_ticket_tbl_cat_ticket_solicitante1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_ticket_tbl_cat_ticket_solicitante1_idx ON nova_ticket.tbl_bit_ticket USING btree (usuario_solicitante);
 J   DROP INDEX nova_ticket.fk_tbl_bit_ticket_tbl_cat_ticket_solicitante1_idx;
       nova_ticket            vince    false    319            �           1259    24941 *   fk_tbl_bit_ticket_tbl_cat_ticket_tipo1_idx    INDEX     x   CREATE INDEX fk_tbl_bit_ticket_tbl_cat_ticket_tipo1_idx ON nova_ticket.tbl_bit_ticket USING btree (id_cat_ticket_tipo);
 C   DROP INDEX nova_ticket.fk_tbl_bit_ticket_tbl_cat_ticket_tipo1_idx;
       nova_ticket            vince    false    319            �           1259    25080 ,   tbl_bit_ticket_vista_id_bit_ticket_vista_idx    INDEX     �   CREATE INDEX tbl_bit_ticket_vista_id_bit_ticket_vista_idx ON nova_ticket.tbl_bit_ticket_vista USING btree (id_bit_ticket_vista);
 E   DROP INDEX nova_ticket.tbl_bit_ticket_vista_id_bit_ticket_vista_idx;
       nova_ticket            vince    false    327            �           1259    26535 /   fk_tbl_bit_detalle_version_tbl_cat_version1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_detalle_version_tbl_cat_version1_idx ON nova_version.tbl_bit_version_detalle USING btree (id_cat_version);
 I   DROP INDEX nova_version.fk_tbl_bit_detalle_version_tbl_cat_version1_idx;
       nova_version            vince    false    388            �           1259    26536 4   fk_tbl_bit_version_detalle_tbl_cat_version_tipo1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_version_detalle_tbl_cat_version_tipo1_idx ON nova_version.tbl_bit_version_detalle USING btree (id_cat_version_categoria);
 N   DROP INDEX nova_version.fk_tbl_bit_version_detalle_tbl_cat_version_tipo1_idx;
       nova_version            vince    false    388            �           1259    26537 <   fk_tbl_bit_version_detalle_tipo_tbl_bit_version_detalle1_idx    INDEX     �   CREATE INDEX fk_tbl_bit_version_detalle_tipo_tbl_bit_version_detalle1_idx ON nova_version.tbl_bit_version_detalle_resumen USING btree (id_bit_version_detalle);
 V   DROP INDEX nova_version.fk_tbl_bit_version_detalle_tipo_tbl_bit_version_detalle1_idx;
       nova_version            vince    false    390                       1259    23997 ,   fk_tbl_cat_departamento_tbl_cat_empresa1_idx    INDEX     y   CREATE INDEX fk_tbl_cat_departamento_tbl_cat_empresa1_idx ON usuarios.tbl_cat_departamento USING btree (id_cat_empresa);
 B   DROP INDEX usuarios.fk_tbl_cat_departamento_tbl_cat_empresa1_idx;
       usuarios            vince    false    236                       1259    23998 +   fk_tbl_cat_equipo_tbl_cat_departamento1_idx    INDEX     w   CREATE INDEX fk_tbl_cat_equipo_tbl_cat_departamento1_idx ON usuarios.tbl_cat_equipo USING btree (id_cat_departamento);
 A   DROP INDEX usuarios.fk_tbl_cat_equipo_tbl_cat_departamento1_idx;
       usuarios            vince    false    238                       1259    24001 3   fk_tbl_cat_permiso_grupo_tbl_cat_permiso_nivel1_idx    INDEX     �   CREATE INDEX fk_tbl_cat_permiso_grupo_tbl_cat_permiso_nivel1_idx ON usuarios.tbl_cat_permiso_grupo USING btree (id_cat_permiso_nivel);
 I   DROP INDEX usuarios.fk_tbl_cat_permiso_grupo_tbl_cat_permiso_nivel1_idx;
       usuarios            vince    false    244            !           1259    24005 >   fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_aplicativo1_idx    INDEX     �   CREATE INDEX fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_aplicativo1_idx ON usuarios.tbl_det_grupo_asignacion_aplicativo USING btree (id_cat_aplicativo);
 T   DROP INDEX usuarios.fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_aplicativo1_idx;
       usuarios            vince    false    248            "           1259    24004 ?   fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_permiso_grup_idx    INDEX     �   CREATE INDEX fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_permiso_grup_idx ON usuarios.tbl_det_grupo_asignacion_aplicativo USING btree (id_cat_permiso_grupo);
 U   DROP INDEX usuarios.fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_permiso_grup_idx;
       usuarios            vince    false    248            '           1259    24006 >   fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_accion1_idx    INDEX     �   CREATE INDEX fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_accion1_idx ON usuarios.tbl_det_nivel_asignacion_accion USING btree (id_cat_permiso_accion);
 T   DROP INDEX usuarios.fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_accion1_idx;
       usuarios            vince    false    252            (           1259    24007 =   fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_nivel1_idx    INDEX     �   CREATE INDEX fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_nivel1_idx ON usuarios.tbl_det_nivel_asignacion_accion USING btree (id_cat_permiso_nivel);
 S   DROP INDEX usuarios.fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_nivel1_idx;
       usuarios            vince    false    252                       1259    23999 8   fk_tbl_det_usuario_asignacion_equipo_tbl_cat_equipo1_idx    INDEX     �   CREATE INDEX fk_tbl_det_usuario_asignacion_equipo_tbl_cat_equipo1_idx ON usuarios.tbl_det_usuario_asignacion_equipo USING btree (id_cat_equipo);
 N   DROP INDEX usuarios.fk_tbl_det_usuario_asignacion_equipo_tbl_cat_equipo1_idx;
       usuarios            vince    false    240                       1259    24000 9   fk_tbl_det_usuario_asignacion_equipo_tbl_cat_usuario1_idx    INDEX     �   CREATE INDEX fk_tbl_det_usuario_asignacion_equipo_tbl_cat_usuario1_idx ON usuarios.tbl_det_usuario_asignacion_equipo USING btree (id_cat_usuario);
 O   DROP INDEX usuarios.fk_tbl_det_usuario_asignacion_equipo_tbl_cat_usuario1_idx;
       usuarios            vince    false    240                       1259    24003 ?   fk_tbl_det_usuario_asignacion_permiso_tbl_cat_permiso_grupo_idx    INDEX     �   CREATE INDEX fk_tbl_det_usuario_asignacion_permiso_tbl_cat_permiso_grupo_idx ON usuarios.tbl_det_usuario_asignacion_permiso USING btree (id_cat_permiso_grupo);
 U   DROP INDEX usuarios.fk_tbl_det_usuario_asignacion_permiso_tbl_cat_permiso_grupo_idx;
       usuarios            vince    false    246                       1259    24002 :   fk_tbl_det_usuario_asignacion_permiso_tbl_cat_usuario1_idx    INDEX     �   CREATE INDEX fk_tbl_det_usuario_asignacion_permiso_tbl_cat_usuario1_idx ON usuarios.tbl_det_usuario_asignacion_permiso USING btree (id_cat_usuario);
 P   DROP INDEX usuarios.fk_tbl_det_usuario_asignacion_permiso_tbl_cat_usuario1_idx;
       usuarios            vince    false    246            s           1259    24815 ,   newtable_id_det_puesto_asignacion_equipo_idx    INDEX     �   CREATE INDEX newtable_id_det_puesto_asignacion_equipo_idx ON usuarios.tbl_det_puesto_asignacion_equipo USING btree (id_det_puesto_asignacion_equipo);
 B   DROP INDEX usuarios.newtable_id_det_puesto_asignacion_equipo_idx;
       usuarios            vince    false    305            j           1259    24679 ?   tbl_det_departamento_asignacion_responsable_id_det_departamento    INDEX     �   CREATE INDEX tbl_det_departamento_asignacion_responsable_id_det_departamento ON usuarios.tbl_det_departamento_asignacion_responsable USING btree (id_det_departamento_asignacion_responsable);
 U   DROP INDEX usuarios.tbl_det_departamento_asignacion_responsable_id_det_departamento;
       usuarios            vince    false    299            g           1259    24684 ?   tbl_det_empresa_asignacion_responsable_id_det_empresa_asignacio    INDEX     �   CREATE INDEX tbl_det_empresa_asignacion_responsable_id_det_empresa_asignacio ON usuarios.tbl_det_empresa_asignacion_responsable USING btree (id_det_empresa_asignacion_responsable);
 U   DROP INDEX usuarios.tbl_det_empresa_asignacion_responsable_id_det_empresa_asignacio;
       usuarios            vince    false    297            m           1259    24685 ?   tbl_det_equipo_asignacion_responsable_id_det_equipo_asignacion_    INDEX     �   CREATE INDEX tbl_det_equipo_asignacion_responsable_id_det_equipo_asignacion_ ON usuarios.tbl_det_equipo_asignacion_responsable USING btree (id_det_equipo_asignacion_responsable);
 U   DROP INDEX usuarios.tbl_det_equipo_asignacion_responsable_id_det_equipo_asignacion_;
       usuarios            vince    false    301            N           2606    26392     tbl_cat_cuenta tbl_cat_cuenta_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta
    ADD CONSTRAINT tbl_cat_cuenta_fk FOREIGN KEY (id_cat_cuenta_clasificacion) REFERENCES compras_cuenta.tbl_cat_cuenta_clasificacion(id_cat_cuenta_clasificacion);
 R   ALTER TABLE ONLY compras_cuenta.tbl_cat_cuenta DROP CONSTRAINT tbl_cat_cuenta_fk;
       compras_cuenta          vince    false    4052    382    370            :           2606    26291 2   tbl_cat_orden_compra fk_tbl_cat_oc_tbl_cat_moneda1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_cat_oc_tbl_cat_moneda1 FOREIGN KEY (id_cat_moneda) REFERENCES compras_orden_compra.tbl_cat_moneda(id_cat_moneda);
 j   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_cat_oc_tbl_cat_moneda1;
       compras_orden_compra          vince    false    352    4024    366            ;           2606    26306 E   tbl_cat_orden_compra fk_tbl_cat_orden_compra_tbl_cat_cuenta_bancaria1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_cuenta_bancaria1 FOREIGN KEY (id_cat_cuenta_bancaria) REFERENCES compras_cuenta_bancaria.tbl_cat_cuenta_bancaria(id_cat_cuenta_bancaria);
 }   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_cuenta_bancaria1;
       compras_orden_compra          vince    false    358    4030    366            <           2606    26311 I   tbl_cat_orden_compra fk_tbl_cat_orden_compra_tbl_cat_orden_compra_estado1    FK CONSTRAINT       ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_orden_compra_estado1 FOREIGN KEY (id_cat_orden_compra_estado) REFERENCES compras_orden_compra.tbl_cat_orden_compra_estado(id_cat_orden_compra_estado);
 �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_orden_compra_estado1;
       compras_orden_compra          vince    false    4032    366    360            =           2606    26301 N   tbl_cat_orden_compra fk_tbl_cat_orden_compra_tbl_cat_orden_compra_metodo_pago1    FK CONSTRAINT       ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_orden_compra_metodo_pago1 FOREIGN KEY (id_cat_orden_compra_metodo_pago) REFERENCES compras_orden_compra.tbl_cat_orden_compra_metodo_pago(id_cat_orden_compra_metodo_pago);
 �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_orden_compra_metodo_pago1;
       compras_orden_compra          vince    false    366    4028    356            >           2606    26296 M   tbl_cat_orden_compra fk_tbl_cat_orden_compra_tbl_cat_orden_compra_tipo_cuota1    FK CONSTRAINT       ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_orden_compra_tipo_cuota1 FOREIGN KEY (id_cat_orden_compra_tipo_cuota) REFERENCES compras_orden_compra.tbl_cat_orden_compra_tipo_cuota(id_cat_orden_compra_tipo_cuota);
 �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_orden_compra_tipo_cuota1;
       compras_orden_compra          vince    false    354    4026    366            ?           2606    26316 A   tbl_cat_orden_compra fk_tbl_cat_orden_compra_tbl_cat_presupuesto1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_presupuesto1 FOREIGN KEY (id_cat_presupuesto) REFERENCES compras_presupuesto.tbl_cat_presupuesto(id_cat_presupuesto);
 y   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_presupuesto1;
       compras_orden_compra          vince    false    364    4038    366            @           2606    26321 ?   tbl_cat_orden_compra fk_tbl_cat_orden_compra_tbl_cat_proveedor1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_proveedor1 FOREIGN KEY (id_cat_proveedor) REFERENCES compras_proveedor.tbl_cat_proveedor(id_cat_proveedor);
 w   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_cat_orden_compra_tbl_cat_proveedor1;
       compras_orden_compra          vince    false    4004    339    366            A           2606    26326 .   tbl_cat_orden_compra fk_tbl_det_oc_tbl_cat_oc1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT fk_tbl_det_oc_tbl_cat_oc1 FOREIGN KEY (id_cat_orden_compra) REFERENCES compras_orden_compra.tbl_cat_orden_compra(id_cat_orden_compra);
 f   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT fk_tbl_det_oc_tbl_cat_oc1;
       compras_orden_compra          vince    false    366    4047    366            B           2606    26423 6   tbl_cat_orden_compra tbl_cat_orden_compra_aprobador_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT tbl_cat_orden_compra_aprobador_fk FOREIGN KEY (aprobador_presupuesto) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 n   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT tbl_cat_orden_compra_aprobador_fk;
       compras_orden_compra          vince    false    366    3851    232            C           2606    26418 8   tbl_cat_orden_compra tbl_cat_orden_compra_solicitante_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT tbl_cat_orden_compra_solicitante_fk FOREIGN KEY (solicitante) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 p   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT tbl_cat_orden_compra_solicitante_fk;
       compras_orden_compra          vince    false    232    366    3851            D           2606    26428 6   tbl_cat_orden_compra tbl_cat_orden_compra_tesoreria_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra
    ADD CONSTRAINT tbl_cat_orden_compra_tesoreria_fk FOREIGN KEY (aprobador_tesoreria) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 n   ALTER TABLE ONLY compras_orden_compra.tbl_cat_orden_compra DROP CONSTRAINT tbl_cat_orden_compra_tesoreria_fk;
       compras_orden_compra          vince    false    3851    232    366            K           2606    26366 M   tbl_bit_presupuesto_ajuste fk_tbl_bit_presupuesto_ajuste_tbl_det_presupuesto1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste
    ADD CONSTRAINT fk_tbl_bit_presupuesto_ajuste_tbl_det_presupuesto1 FOREIGN KEY (id_det_presupuesto) REFERENCES compras_presupuesto.tbl_det_presupuesto(id_det_presupuesto);
 �   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste DROP CONSTRAINT fk_tbl_bit_presupuesto_ajuste_tbl_det_presupuesto1;
       compras_presupuesto          vince    false    380    4056    372            7           2606    26286 F   tbl_cat_presupuesto fk_tbl_cat_presupuesto_tbl_cat_presupuesto_estado1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto
    ADD CONSTRAINT fk_tbl_cat_presupuesto_tbl_cat_presupuesto_estado1 FOREIGN KEY (id_cat_presupuesto_estado) REFERENCES compras_presupuesto.tbl_cat_presupuesto_estado(id_cat_presupuesto_estado);
 }   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto DROP CONSTRAINT fk_tbl_cat_presupuesto_tbl_cat_presupuesto_estado1;
       compras_presupuesto          vince    false    4034    362    364            E           2606    26336 ?   tbl_det_presupuesto fk_tbl_det_presupuesto_tbl_cat_presupuesto1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_det_presupuesto
    ADD CONSTRAINT fk_tbl_det_presupuesto_tbl_cat_presupuesto1 FOREIGN KEY (id_cat_presupuesto) REFERENCES compras_presupuesto.tbl_cat_presupuesto(id_cat_presupuesto);
 v   ALTER TABLE ONLY compras_presupuesto.tbl_det_presupuesto DROP CONSTRAINT fk_tbl_det_presupuesto_tbl_cat_presupuesto1;
       compras_presupuesto          vince    false    372    364    4038            L           2606    26408 >   tbl_bit_presupuesto_ajuste tbl_bit_presupuesto_ajuste_abono_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste
    ADD CONSTRAINT tbl_bit_presupuesto_ajuste_abono_fk FOREIGN KEY (cuenta_abono) REFERENCES compras_cuenta.tbl_cat_cuenta(id_cat_cuenta);
 u   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste DROP CONSTRAINT tbl_bit_presupuesto_ajuste_abono_fk;
       compras_presupuesto          vince    false    382    4074    380            M           2606    26413 @   tbl_bit_presupuesto_ajuste tbl_bit_presupuesto_ajuste_cargo_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste
    ADD CONSTRAINT tbl_bit_presupuesto_ajuste_cargo_fk_1 FOREIGN KEY (cuenta_cargo) REFERENCES compras_cuenta.tbl_cat_cuenta(id_cat_cuenta);
 w   ALTER TABLE ONLY compras_presupuesto.tbl_bit_presupuesto_ajuste DROP CONSTRAINT tbl_bit_presupuesto_ajuste_cargo_fk_1;
       compras_presupuesto          vince    false    382    380    4074            8           2606    26560 2   tbl_cat_presupuesto tbl_cat_presupuesto_empresa_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto
    ADD CONSTRAINT tbl_cat_presupuesto_empresa_fk FOREIGN KEY (id_cat_empresa) REFERENCES usuarios.tbl_cat_empresa(id_cat_empresa);
 i   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto DROP CONSTRAINT tbl_cat_presupuesto_empresa_fk;
       compras_presupuesto          vince    false    364    234    3853            9           2606    26448 *   tbl_cat_presupuesto tbl_cat_presupuesto_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto
    ADD CONSTRAINT tbl_cat_presupuesto_fk FOREIGN KEY (usuario_responsable) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 a   ALTER TABLE ONLY compras_presupuesto.tbl_cat_presupuesto DROP CONSTRAINT tbl_cat_presupuesto_fk;
       compras_presupuesto          vince    false    232    364    3851            F           2606    26397 *   tbl_det_presupuesto tbl_det_presupuesto_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_presupuesto.tbl_det_presupuesto
    ADD CONSTRAINT tbl_det_presupuesto_fk FOREIGN KEY (id_cat_cuenta) REFERENCES compras_cuenta.tbl_cat_cuenta(id_cat_cuenta);
 a   ALTER TABLE ONLY compras_presupuesto.tbl_det_presupuesto DROP CONSTRAINT tbl_det_presupuesto_fk;
       compras_presupuesto          vince    false    372    382    4074            /           2606    26254 @   tbl_cat_producto fk_tbl_cat_producto_tbl_cat_producto_categoria1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_producto.tbl_cat_producto
    ADD CONSTRAINT fk_tbl_cat_producto_tbl_cat_producto_categoria1 FOREIGN KEY (id_cat_producto_categoria) REFERENCES compras_producto.tbl_cat_producto_categoria(id_cat_producto_categoria);
 t   ALTER TABLE ONLY compras_producto.tbl_cat_producto DROP CONSTRAINT fk_tbl_cat_producto_tbl_cat_producto_categoria1;
       compras_producto          vince    false    341    344    4006            0           2606    26264 D   tbl_cat_producto fk_tbl_cat_producto_tbl_cat_producto_unidad_medida1    FK CONSTRAINT       ALTER TABLE ONLY compras_producto.tbl_cat_producto
    ADD CONSTRAINT fk_tbl_cat_producto_tbl_cat_producto_unidad_medida1 FOREIGN KEY (id_cat_producto_unidad_medida) REFERENCES compras_producto.tbl_cat_producto_unidad_medida(id_cat_producto_unidad_medida);
 x   ALTER TABLE ONLY compras_producto.tbl_cat_producto DROP CONSTRAINT fk_tbl_cat_producto_tbl_cat_producto_unidad_medida1;
       compras_producto          vince    false    343    344    4008            1           2606    26259 7   tbl_cat_producto fk_tbl_cat_producto_tbl_cat_proveedor1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_producto.tbl_cat_producto
    ADD CONSTRAINT fk_tbl_cat_producto_tbl_cat_proveedor1 FOREIGN KEY (id_cat_proveedor) REFERENCES compras_proveedor.tbl_cat_proveedor(id_cat_proveedor);
 k   ALTER TABLE ONLY compras_producto.tbl_cat_producto DROP CONSTRAINT fk_tbl_cat_producto_tbl_cat_proveedor1;
       compras_producto          vince    false    344    339    4004            2           2606    26433 $   tbl_cat_producto tbl_cat_producto_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_producto.tbl_cat_producto
    ADD CONSTRAINT tbl_cat_producto_fk FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 X   ALTER TABLE ONLY compras_producto.tbl_cat_producto DROP CONSTRAINT tbl_cat_producto_fk;
       compras_producto          vince    false    232    3851    344            ,           2606    26244 >   tbl_cat_proveedor fk_tbl_cat_proveedor_tbl_cat_proveedor_giro1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor
    ADD CONSTRAINT fk_tbl_cat_proveedor_tbl_cat_proveedor_giro1 FOREIGN KEY (id_cat_proveedor_giro) REFERENCES compras_proveedor.tbl_cat_proveedor_giro(id_cat_proveedor_giro);
 s   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor DROP CONSTRAINT fk_tbl_cat_proveedor_tbl_cat_proveedor_giro1;
       compras_proveedor          vince    false    3998    339    335            -           2606    26249 >   tbl_cat_proveedor fk_tbl_cat_proveedor_tbl_cat_proveedor_tipo1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor
    ADD CONSTRAINT fk_tbl_cat_proveedor_tbl_cat_proveedor_tipo1 FOREIGN KEY (id_cat_proveedor_tipo) REFERENCES compras_proveedor.tbl_cat_proveedor_tipo(id_cat_proveedor_tipo);
 s   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor DROP CONSTRAINT fk_tbl_cat_proveedor_tbl_cat_proveedor_tipo1;
       compras_proveedor          vince    false    4000    339    337            .           2606    26438 &   tbl_cat_proveedor tbl_cat_proveedor_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor
    ADD CONSTRAINT tbl_cat_proveedor_fk FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 [   ALTER TABLE ONLY compras_proveedor.tbl_cat_proveedor DROP CONSTRAINT tbl_cat_proveedor_fk;
       compras_proveedor          vince    false    232    339    3851            G           2606    26351 <   tbl_cat_recepcion fk_tbl_cat_recepcion_tbl_cat_orden_compra1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion
    ADD CONSTRAINT fk_tbl_cat_recepcion_tbl_cat_orden_compra1 FOREIGN KEY (id_cat_orden_compra) REFERENCES compras_orden_compra.tbl_cat_orden_compra(id_cat_orden_compra);
 q   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion DROP CONSTRAINT fk_tbl_cat_recepcion_tbl_cat_orden_compra1;
       compras_recepcion          vince    false    4047    366    376            H           2606    26346 @   tbl_cat_recepcion fk_tbl_cat_recepcion_tbl_cat_recepcion_estado1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion
    ADD CONSTRAINT fk_tbl_cat_recepcion_tbl_cat_recepcion_estado1 FOREIGN KEY (id_cat_recepcion_estado) REFERENCES compras_recepcion.tbl_cat_recepcion_estado(id_cat_recepcion_estado);
 u   ALTER TABLE ONLY compras_recepcion.tbl_cat_recepcion DROP CONSTRAINT fk_tbl_cat_recepcion_tbl_cat_recepcion_estado1;
       compras_recepcion          vince    false    376    4058    374            I           2606    26361 8   tbl_det_recepcion fk_tbl_det_recepcion_tbl_cat_producto1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_recepcion.tbl_det_recepcion
    ADD CONSTRAINT fk_tbl_det_recepcion_tbl_cat_producto1 FOREIGN KEY (id_cat_producto) REFERENCES compras_producto.tbl_cat_producto(id_cat_producto);
 m   ALTER TABLE ONLY compras_recepcion.tbl_det_recepcion DROP CONSTRAINT fk_tbl_det_recepcion_tbl_cat_producto1;
       compras_recepcion          vince    false    4013    344    378            J           2606    26356 9   tbl_det_recepcion fk_tbl_det_recepcion_tbl_cat_recepcion1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_recepcion.tbl_det_recepcion
    ADD CONSTRAINT fk_tbl_det_recepcion_tbl_cat_recepcion1 FOREIGN KEY (id_cat_recepcion) REFERENCES compras_recepcion.tbl_cat_recepcion(id_cat_recepcion);
 n   ALTER TABLE ONLY compras_recepcion.tbl_det_recepcion DROP CONSTRAINT fk_tbl_det_recepcion_tbl_cat_recepcion1;
       compras_recepcion          vince    false    378    4062    376            3           2606    26269 @   tbl_cat_solicitud fk_tbl_cat_solicitud_tbl_cat_solicitud_estado1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud
    ADD CONSTRAINT fk_tbl_cat_solicitud_tbl_cat_solicitud_estado1 FOREIGN KEY (id_cat_solicitud_estado) REFERENCES compras_solicitud.tbl_cat_solicitud_estado(id_cat_solicitud_estado);
 u   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud DROP CONSTRAINT fk_tbl_cat_solicitud_tbl_cat_solicitud_estado1;
       compras_solicitud          vince    false    4015    348    346            5           2606    26281 8   tbl_det_solicitud fk_tbl_det_solicitud_tbl_cat_producto1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_solicitud.tbl_det_solicitud
    ADD CONSTRAINT fk_tbl_det_solicitud_tbl_cat_producto1 FOREIGN KEY (id_cat_producto) REFERENCES compras_producto.tbl_cat_producto(id_cat_producto);
 m   ALTER TABLE ONLY compras_solicitud.tbl_det_solicitud DROP CONSTRAINT fk_tbl_det_solicitud_tbl_cat_producto1;
       compras_solicitud          vince    false    344    4013    350            6           2606    26274 9   tbl_det_solicitud fk_tbl_det_solicitud_tbl_cat_solicitud1    FK CONSTRAINT     �   ALTER TABLE ONLY compras_solicitud.tbl_det_solicitud
    ADD CONSTRAINT fk_tbl_det_solicitud_tbl_cat_solicitud1 FOREIGN KEY (id_cat_solicitud) REFERENCES compras_solicitud.tbl_cat_solicitud(id_cat_solicitud);
 n   ALTER TABLE ONLY compras_solicitud.tbl_det_solicitud DROP CONSTRAINT fk_tbl_det_solicitud_tbl_cat_solicitud1;
       compras_solicitud          vince    false    350    348    4018            4           2606    26443 &   tbl_cat_solicitud tbl_cat_solicitud_fk    FK CONSTRAINT     �   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud
    ADD CONSTRAINT tbl_cat_solicitud_fk FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 [   ALTER TABLE ONLY compras_solicitud.tbl_cat_solicitud DROP CONSTRAINT tbl_cat_solicitud_fk;
       compras_solicitud          vince    false    3851    348    232                       2606    24383 N   tbl_bit_aplicacion_registro fk_tbl_bit_aplicacion_registro_tbl_cat_aplicacion1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_aplicacion.tbl_bit_aplicacion_registro
    ADD CONSTRAINT fk_tbl_bit_aplicacion_registro_tbl_cat_aplicacion1 FOREIGN KEY (id_cat_aplicacion) REFERENCES nova_aplicacion.tbl_cat_aplicacion(id_cat_aplicacion);
 �   ALTER TABLE ONLY nova_aplicacion.tbl_bit_aplicacion_registro DROP CONSTRAINT fk_tbl_bit_aplicacion_registro_tbl_cat_aplicacion1;
       nova_aplicacion          vince    false    256    3886    258                       2606    25673 :   tbl_bit_aplicacion_registro tbl_bit_aplicacion_registro_fk    FK CONSTRAINT     �   ALTER TABLE ONLY nova_aplicacion.tbl_bit_aplicacion_registro
    ADD CONSTRAINT tbl_bit_aplicacion_registro_fk FOREIGN KEY (id_bit_tarea_registro) REFERENCES nova_proceso_tarea.tbl_bit_tarea_registro(id_bit_tarea_registro);
 m   ALTER TABLE ONLY nova_aplicacion.tbl_bit_aplicacion_registro DROP CONSTRAINT tbl_bit_aplicacion_registro_fk;
       nova_aplicacion          vince    false    279    258    3919            *           2606    25505 B   tbl_bit_dispositivo_diagnostico tbl_bit_dispositivo_diagnostico_fk    FK CONSTRAINT     �   ALTER TABLE ONLY nova_dispositivo.tbl_bit_dispositivo_diagnostico
    ADD CONSTRAINT tbl_bit_dispositivo_diagnostico_fk FOREIGN KEY (id_cat_dispositivo) REFERENCES nova_dispositivo.tbl_cat_dispositivo(id_cat_dispositivo);
 v   ALTER TABLE ONLY nova_dispositivo.tbl_bit_dispositivo_diagnostico DROP CONSTRAINT tbl_bit_dispositivo_diagnostico_fk;
       nova_dispositivo          vince    false    329    3927    285            	           2606    24388 5   tbl_cat_falta fk_tbl_cat_falta_tbl_cat_justificacion1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_falta.tbl_cat_falta
    ADD CONSTRAINT fk_tbl_cat_falta_tbl_cat_justificacion1 FOREIGN KEY (id_cat_justificacion) REFERENCES nova_falta.tbl_cat_justificacion(id_cat_justificacion);
 c   ALTER TABLE ONLY nova_falta.tbl_cat_falta DROP CONSTRAINT fk_tbl_cat_falta_tbl_cat_justificacion1;
    
   nova_falta          vince    false    3891    260    264            
           2606    24393 2   tbl_cat_falta fk_tbl_cat_falta_tbl_cat_tipo_falta1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_falta.tbl_cat_falta
    ADD CONSTRAINT fk_tbl_cat_falta_tbl_cat_tipo_falta1 FOREIGN KEY (id_cat_tipo_falta) REFERENCES nova_falta.tbl_cat_tipo_falta(id_cat_tipo_falta);
 `   ALTER TABLE ONLY nova_falta.tbl_cat_falta DROP CONSTRAINT fk_tbl_cat_falta_tbl_cat_tipo_falta1;
    
   nova_falta          vince    false    262    3893    264                       2606    24526 G   tbl_bit_horario_marcaje fk_tbl_bit_horario_marcaje_tbl_cat_dispositivo1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_horario.tbl_bit_horario_marcaje
    ADD CONSTRAINT fk_tbl_bit_horario_marcaje_tbl_cat_dispositivo1 FOREIGN KEY (id_cat_dispositivo) REFERENCES nova_dispositivo.tbl_cat_dispositivo(id_cat_dispositivo);
 w   ALTER TABLE ONLY nova_horario.tbl_bit_horario_marcaje DROP CONSTRAINT fk_tbl_bit_horario_marcaje_tbl_cat_dispositivo1;
       nova_horario          vince    false    3927    293    285                       2606    24521 J   tbl_bit_horario_marcaje fk_tbl_bit_horario_marcaje_tbl_cat_horario_accion1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_horario.tbl_bit_horario_marcaje
    ADD CONSTRAINT fk_tbl_bit_horario_marcaje_tbl_cat_horario_accion1 FOREIGN KEY (id_cat_horario_accion) REFERENCES nova_horario.tbl_cat_horario_accion(id_cat_horario_accion);
 z   ALTER TABLE ONLY nova_horario.tbl_bit_horario_marcaje DROP CONSTRAINT fk_tbl_bit_horario_marcaje_tbl_cat_horario_accion1;
       nova_horario          vince    false    293    287    3929                       2606    24516 ]   tbl_det_horario_asignacion_dia fk_tbl_det_horario_asignacion_dia_tbl_det_horario_asignacion_1    FK CONSTRAINT       ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_dia
    ADD CONSTRAINT fk_tbl_det_horario_asignacion_dia_tbl_det_horario_asignacion_1 FOREIGN KEY (id_det_horario_asignacion_usuario) REFERENCES nova_horario.tbl_det_horario_asignacion_usuario(id_det_horario_asignacion_usuario);
 �   ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_dia DROP CONSTRAINT fk_tbl_det_horario_asignacion_dia_tbl_det_horario_asignacion_1;
       nova_horario          vince    false    291    3931    289                       2606    24511 \   tbl_det_horario_asignacion_dia fk_tbl_det_horario_asignacion_usuario_tbl_cat_horario_accion1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_dia
    ADD CONSTRAINT fk_tbl_det_horario_asignacion_usuario_tbl_cat_horario_accion1 FOREIGN KEY (id_cat_horario_accion) REFERENCES nova_horario.tbl_cat_horario_accion(id_cat_horario_accion);
 �   ALTER TABLE ONLY nova_horario.tbl_det_horario_asignacion_dia DROP CONSTRAINT fk_tbl_det_horario_asignacion_usuario_tbl_cat_horario_accion1;
       nova_horario          vince    false    291    3929    287                       2606    24403 Y   tbl_cat_sla_campo_evaluacion fk_tbl_cat_sla_campo_evaluacion_tbl_cat_sla_campo_categoria1    FK CONSTRAINT       ALTER TABLE ONLY nova_metrica.tbl_cat_sla_campo_evaluacion
    ADD CONSTRAINT fk_tbl_cat_sla_campo_evaluacion_tbl_cat_sla_campo_categoria1 FOREIGN KEY (id_cat_sla_campo_categoria) REFERENCES nova_metrica.tbl_cat_sla_campo_categoria(id_cat_sla_campo_categoria);
 �   ALTER TABLE ONLY nova_metrica.tbl_cat_sla_campo_evaluacion DROP CONSTRAINT fk_tbl_cat_sla_campo_evaluacion_tbl_cat_sla_campo_categoria1;
       nova_metrica          vince    false    267    265    3899                       2606    24408 .   tbl_cat_sla fk_tbl_cat_sla_tbl_cat_sla_estado1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_metrica.tbl_cat_sla
    ADD CONSTRAINT fk_tbl_cat_sla_tbl_cat_sla_estado1 FOREIGN KEY (id_cat_sla_estado) REFERENCES nova_metrica.tbl_cat_sla_estado(id_cat_sla_estado);
 ^   ALTER TABLE ONLY nova_metrica.tbl_cat_sla DROP CONSTRAINT fk_tbl_cat_sla_tbl_cat_sla_estado1;
       nova_metrica          vince    false    3904    271    269                       2606    24423 L   tbl_bit_tarea_comentario fk_tbl_bit_tarea_comentario_tbl_bit_tarea_registro1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_comentario
    ADD CONSTRAINT fk_tbl_bit_tarea_comentario_tbl_bit_tarea_registro1 FOREIGN KEY (id_bit_tarea_registro) REFERENCES nova_proceso_tarea.tbl_bit_tarea_registro(id_bit_tarea_registro);
 �   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_comentario DROP CONSTRAINT fk_tbl_bit_tarea_comentario_tbl_bit_tarea_registro1;
       nova_proceso_tarea          vince    false    279    3919    281                       2606    24418 ?   tbl_bit_tarea_registro fk_tbl_bit_tarea_registro_tbl_cat_tarea1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_registro
    ADD CONSTRAINT fk_tbl_bit_tarea_registro_tbl_cat_tarea1 FOREIGN KEY (id_cat_tarea) REFERENCES nova_proceso_tarea.tbl_cat_tarea(id_cat_tarea);
 u   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_registro DROP CONSTRAINT fk_tbl_bit_tarea_registro_tbl_cat_tarea1;
       nova_proceso_tarea          vince    false    3913    279    275                       2606    24413 F   tbl_bit_tarea_registro fk_tbl_bit_tarea_registro_tbl_cat_tarea_estado1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_registro
    ADD CONSTRAINT fk_tbl_bit_tarea_registro_tbl_cat_tarea_estado1 FOREIGN KEY (id_cat_tarea_estado) REFERENCES nova_proceso_tarea.tbl_cat_tarea_estado(id_cat_tarea_estado);
 |   ALTER TABLE ONLY nova_proceso_tarea.tbl_bit_tarea_registro DROP CONSTRAINT fk_tbl_bit_tarea_registro_tbl_cat_tarea_estado1;
       nova_proceso_tarea          vince    false    277    279    3915                       2606    24398 /   tbl_cat_tarea fk_tbl_cat_tarea_tbl_cat_proceso1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_tarea
    ADD CONSTRAINT fk_tbl_cat_tarea_tbl_cat_proceso1 FOREIGN KEY (id_cat_proceso) REFERENCES nova_proceso_tarea.tbl_cat_proceso(id_cat_proceso);
 e   ALTER TABLE ONLY nova_proceso_tarea.tbl_cat_tarea DROP CONSTRAINT fk_tbl_cat_tarea_tbl_cat_proceso1;
       nova_proceso_tarea          vince    false    275    273    3909                       2606    25227 G   tbl_det_proceso_asignacion_puesto tbl_det_proceso_asignacion_proceso_fk    FK CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_det_proceso_asignacion_puesto
    ADD CONSTRAINT tbl_det_proceso_asignacion_proceso_fk FOREIGN KEY (id_cat_proceso) REFERENCES nova_proceso_tarea.tbl_cat_proceso(id_cat_proceso);
 }   ALTER TABLE ONLY nova_proceso_tarea.tbl_det_proceso_asignacion_puesto DROP CONSTRAINT tbl_det_proceso_asignacion_proceso_fk;
       nova_proceso_tarea          vince    false    3909    273    283                       2606    25233 F   tbl_det_proceso_asignacion_puesto tbl_det_proceso_asignacion_puesto_fk    FK CONSTRAINT     �   ALTER TABLE ONLY nova_proceso_tarea.tbl_det_proceso_asignacion_puesto
    ADD CONSTRAINT tbl_det_proceso_asignacion_puesto_fk FOREIGN KEY (id_cat_puesto) REFERENCES usuarios.tbl_cat_puesto(id_cat_puesto);
 |   ALTER TABLE ONLY nova_proceso_tarea.tbl_det_proceso_asignacion_puesto DROP CONSTRAINT tbl_det_proceso_asignacion_puesto_fk;
       nova_proceso_tarea          vince    false    3849    283    231            &           2606    25007 N   tbl_bit_ticket_detalle_accion fk_tbl_bit_ticket_detalle_accion_tbl_bit_ticket1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_accion
    ADD CONSTRAINT fk_tbl_bit_ticket_detalle_accion_tbl_bit_ticket1 FOREIGN KEY (id_bit_ticket) REFERENCES nova_ticket.tbl_bit_ticket(id_bit_ticket);
 }   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_accion DROP CONSTRAINT fk_tbl_bit_ticket_detalle_accion_tbl_bit_ticket1;
       nova_ticket          vince    false    3977    319    325            '           2606    25002 T   tbl_bit_ticket_detalle_accion fk_tbl_bit_ticket_detalle_accion_tbl_cat_ticket_accion    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_accion
    ADD CONSTRAINT fk_tbl_bit_ticket_detalle_accion_tbl_cat_ticket_accion FOREIGN KEY (id_cat_ticket_accion) REFERENCES nova_ticket.tbl_cat_ticket_accion(id_cat_ticket_accion);
 �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_accion DROP CONSTRAINT fk_tbl_bit_ticket_detalle_accion_tbl_cat_ticket_accion;
       nova_ticket          vince    false    307    3959    325            $           2606    24992 V   tbl_bit_ticket_detalle_comentario fk_tbl_bit_ticket_detalle_comentario_tbl_bit_ticket1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_comentario
    ADD CONSTRAINT fk_tbl_bit_ticket_detalle_comentario_tbl_bit_ticket1 FOREIGN KEY (id_bit_ticket) REFERENCES nova_ticket.tbl_bit_ticket(id_bit_ticket);
 �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_detalle_comentario DROP CONSTRAINT fk_tbl_bit_ticket_detalle_comentario_tbl_bit_ticket1;
       nova_ticket          vince    false    3977    319    321            %           2606    24997 H   tbl_bit_ticket_seguimiento fk_tbl_bit_ticket_seguimiento_tbl_bit_ticket1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_seguimiento
    ADD CONSTRAINT fk_tbl_bit_ticket_seguimiento_tbl_bit_ticket1 FOREIGN KEY (id_bit_ticket) REFERENCES nova_ticket.tbl_bit_ticket(id_bit_ticket);
 w   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_seguimiento DROP CONSTRAINT fk_tbl_bit_ticket_seguimiento_tbl_bit_ticket1;
       nova_ticket          vince    false    3977    319    323                       2606    24987 6   tbl_bit_ticket fk_tbl_bit_ticket_tbl_cat_ticket_canal1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket
    ADD CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_canal1 FOREIGN KEY (id_cat_ticket_canal) REFERENCES nova_ticket.tbl_cat_ticket_canal(id_cat_ticket_canal);
 e   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket DROP CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_canal1;
       nova_ticket          vince    false    317    3969    319                        2606    24967 ?   tbl_bit_ticket fk_tbl_bit_ticket_tbl_cat_ticket_estado_proceso1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket
    ADD CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_estado_proceso1 FOREIGN KEY (id_cat_ticket_estado_proceso) REFERENCES nova_ticket.tbl_cat_ticket_estado_proceso(id_cat_ticket_estado_proceso);
 n   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket DROP CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_estado_proceso1;
       nova_ticket          vince    false    311    3963    319            !           2606    24972 B   tbl_bit_ticket fk_tbl_bit_ticket_tbl_cat_ticket_estado_resolucion1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket
    ADD CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_estado_resolucion1 FOREIGN KEY (id_cat_ticket_estado_resolucion) REFERENCES nova_ticket.tbl_cat_ticket_estado_resolucion(id_cat_ticket_estado_resolucion);
 q   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket DROP CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_estado_resolucion1;
       nova_ticket          vince    false    319    313    3965            "           2606    24982 :   tbl_bit_ticket fk_tbl_bit_ticket_tbl_cat_ticket_prioridad1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket
    ADD CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_prioridad1 FOREIGN KEY (id_cat_ticket_prioridad) REFERENCES nova_ticket.tbl_cat_ticket_prioridad(id_cat_ticket_prioridad);
 i   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket DROP CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_prioridad1;
       nova_ticket          vince    false    315    3967    319            #           2606    24962 5   tbl_bit_ticket fk_tbl_bit_ticket_tbl_cat_ticket_tipo1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket
    ADD CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_tipo1 FOREIGN KEY (id_cat_ticket_tipo) REFERENCES nova_ticket.tbl_cat_ticket_tipo(id_cat_ticket_tipo);
 d   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket DROP CONSTRAINT fk_tbl_bit_ticket_tbl_cat_ticket_tipo1;
       nova_ticket          vince    false    3961    319    309            (           2606    25070 ,   tbl_bit_ticket_vista tbl_bit_ticket_vista_fk    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_vista
    ADD CONSTRAINT tbl_bit_ticket_vista_fk FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 [   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_vista DROP CONSTRAINT tbl_bit_ticket_vista_fk;
       nova_ticket          vince    false    327    232    3851            )           2606    25075 .   tbl_bit_ticket_vista tbl_bit_ticket_vista_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_vista
    ADD CONSTRAINT tbl_bit_ticket_vista_fk_1 FOREIGN KEY (id_bit_ticket) REFERENCES nova_ticket.tbl_bit_ticket(id_bit_ticket);
 ]   ALTER TABLE ONLY nova_ticket.tbl_bit_ticket_vista DROP CONSTRAINT tbl_bit_ticket_vista_fk_1;
       nova_ticket          vince    false    3977    319    327            O           2606    26538 C   tbl_bit_version_detalle fk_tbl_bit_detalle_version_tbl_cat_version1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle
    ADD CONSTRAINT fk_tbl_bit_detalle_version_tbl_cat_version1 FOREIGN KEY (id_cat_version) REFERENCES nova_version.tbl_cat_version(id_cat_version);
 s   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle DROP CONSTRAINT fk_tbl_bit_detalle_version_tbl_cat_version1;
       nova_version          vince    false    384    4076    388            P           2606    26543 H   tbl_bit_version_detalle fk_tbl_bit_version_detalle_tbl_cat_version_tipo1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle
    ADD CONSTRAINT fk_tbl_bit_version_detalle_tbl_cat_version_tipo1 FOREIGN KEY (id_cat_version_categoria) REFERENCES nova_version.tbl_cat_version_categoria(id_cat_version_categoria);
 x   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle DROP CONSTRAINT fk_tbl_bit_version_detalle_tbl_cat_version_tipo1;
       nova_version          vince    false    388    4078    386            Q           2606    26548 X   tbl_bit_version_detalle_resumen fk_tbl_bit_version_detalle_tipo_tbl_bit_version_detalle1    FK CONSTRAINT     �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle_resumen
    ADD CONSTRAINT fk_tbl_bit_version_detalle_tipo_tbl_bit_version_detalle1 FOREIGN KEY (id_bit_version_detalle) REFERENCES nova_version.tbl_bit_version_detalle(id_bit_version_detalle);
 �   ALTER TABLE ONLY nova_version.tbl_bit_version_detalle_resumen DROP CONSTRAINT fk_tbl_bit_version_detalle_tipo_tbl_bit_version_detalle1;
       nova_version          vince    false    4082    388    390            �           2606    24013 =   tbl_cat_departamento fk_tbl_cat_departamento_tbl_cat_empresa1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_departamento
    ADD CONSTRAINT fk_tbl_cat_departamento_tbl_cat_empresa1 FOREIGN KEY (id_cat_empresa) REFERENCES usuarios.tbl_cat_empresa(id_cat_empresa);
 i   ALTER TABLE ONLY usuarios.tbl_cat_departamento DROP CONSTRAINT fk_tbl_cat_departamento_tbl_cat_empresa1;
       usuarios          vince    false    236    234    3853            �           2606    24018 6   tbl_cat_equipo fk_tbl_cat_equipo_tbl_cat_departamento1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_equipo
    ADD CONSTRAINT fk_tbl_cat_equipo_tbl_cat_departamento1 FOREIGN KEY (id_cat_departamento) REFERENCES usuarios.tbl_cat_departamento(id_cat_departamento);
 b   ALTER TABLE ONLY usuarios.tbl_cat_equipo DROP CONSTRAINT fk_tbl_cat_equipo_tbl_cat_departamento1;
       usuarios          vince    false    3856    238    236            �           2606    24033 E   tbl_cat_permiso_grupo fk_tbl_cat_permiso_grupo_tbl_cat_permiso_nivel1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_permiso_grupo
    ADD CONSTRAINT fk_tbl_cat_permiso_grupo_tbl_cat_permiso_nivel1 FOREIGN KEY (id_cat_permiso_nivel) REFERENCES usuarios.tbl_cat_permiso_nivel(id_cat_permiso_nivel);
 q   ALTER TABLE ONLY usuarios.tbl_cat_permiso_grupo DROP CONSTRAINT fk_tbl_cat_permiso_grupo_tbl_cat_permiso_nivel1;
       usuarios          vince    false    244    242    3865                       2606    24053 ^   tbl_det_grupo_asignacion_aplicativo fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_aplicativo1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_grupo_asignacion_aplicativo
    ADD CONSTRAINT fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_aplicativo1 FOREIGN KEY (id_cat_aplicativo) REFERENCES usuarios.tbl_cat_aplicativo(id_cat_aplicativo);
 �   ALTER TABLE ONLY usuarios.tbl_det_grupo_asignacion_aplicativo DROP CONSTRAINT fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_aplicativo1;
       usuarios          vince    false    3847    248    229                       2606    24048 a   tbl_det_grupo_asignacion_aplicativo fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_permiso_grupo1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_grupo_asignacion_aplicativo
    ADD CONSTRAINT fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_permiso_grupo1 FOREIGN KEY (id_cat_permiso_grupo) REFERENCES usuarios.tbl_cat_permiso_grupo(id_cat_permiso_grupo);
 �   ALTER TABLE ONLY usuarios.tbl_det_grupo_asignacion_aplicativo DROP CONSTRAINT fk_tbl_det_grupo_asignacion_aplicativo_tbl_cat_permiso_grupo1;
       usuarios          vince    false    3868    248    244                       2606    24058 Z   tbl_det_nivel_asignacion_accion fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_accion1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_nivel_asignacion_accion
    ADD CONSTRAINT fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_accion1 FOREIGN KEY (id_cat_permiso_accion) REFERENCES usuarios.tbl_cat_permiso_accion(id_cat_permiso_accion);
 �   ALTER TABLE ONLY usuarios.tbl_det_nivel_asignacion_accion DROP CONSTRAINT fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_accion1;
       usuarios          vince    false    250    3878    252                       2606    24063 Y   tbl_det_nivel_asignacion_accion fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_nivel1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_nivel_asignacion_accion
    ADD CONSTRAINT fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_nivel1 FOREIGN KEY (id_cat_permiso_nivel) REFERENCES usuarios.tbl_cat_permiso_nivel(id_cat_permiso_nivel);
 �   ALTER TABLE ONLY usuarios.tbl_det_nivel_asignacion_accion DROP CONSTRAINT fk_tbl_det_nivel_asignacion_accion_tbl_cat_permiso_nivel1;
       usuarios          vince    false    3865    252    242            �           2606    24023 V   tbl_det_usuario_asignacion_equipo fk_tbl_det_usuario_asignacion_equipo_tbl_cat_equipo1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_equipo
    ADD CONSTRAINT fk_tbl_det_usuario_asignacion_equipo_tbl_cat_equipo1 FOREIGN KEY (id_cat_equipo) REFERENCES usuarios.tbl_cat_equipo(id_cat_equipo);
 �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_equipo DROP CONSTRAINT fk_tbl_det_usuario_asignacion_equipo_tbl_cat_equipo1;
       usuarios          vince    false    3859    238    240            �           2606    24028 W   tbl_det_usuario_asignacion_equipo fk_tbl_det_usuario_asignacion_equipo_tbl_cat_usuario1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_equipo
    ADD CONSTRAINT fk_tbl_det_usuario_asignacion_equipo_tbl_cat_usuario1 FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_equipo DROP CONSTRAINT fk_tbl_det_usuario_asignacion_equipo_tbl_cat_usuario1;
       usuarios          vince    false    3851    232    240            �           2606    24043 _   tbl_det_usuario_asignacion_permiso fk_tbl_det_usuario_asignacion_permiso_tbl_cat_permiso_grupo1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_permiso
    ADD CONSTRAINT fk_tbl_det_usuario_asignacion_permiso_tbl_cat_permiso_grupo1 FOREIGN KEY (id_cat_permiso_grupo) REFERENCES usuarios.tbl_cat_permiso_grupo(id_cat_permiso_grupo);
 �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_permiso DROP CONSTRAINT fk_tbl_det_usuario_asignacion_permiso_tbl_cat_permiso_grupo1;
       usuarios          vince    false    246    244    3868                        2606    24038 Y   tbl_det_usuario_asignacion_permiso fk_tbl_det_usuario_asignacion_permiso_tbl_cat_usuario1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_permiso
    ADD CONSTRAINT fk_tbl_det_usuario_asignacion_permiso_tbl_cat_usuario1 FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_permiso DROP CONSTRAINT fk_tbl_det_usuario_asignacion_permiso_tbl_cat_usuario1;
       usuarios          vince    false    3851    246    232            +           2606    25742 2   tbl_cat_usuario_dominio tbl_cat_usuario_dominio_fk    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_usuario_dominio
    ADD CONSTRAINT tbl_cat_usuario_dominio_fk FOREIGN KEY (responsable) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 ^   ALTER TABLE ONLY usuarios.tbl_cat_usuario_dominio DROP CONSTRAINT tbl_cat_usuario_dominio_fk;
       usuarios          vince    false    333    3851    232            �           2606    25747 "   tbl_cat_usuario tbl_cat_usuario_fk    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_usuario
    ADD CONSTRAINT tbl_cat_usuario_fk FOREIGN KEY (id_cat_usuario_dominio) REFERENCES usuarios.tbl_cat_usuario_dominio(id_cat_usuario_dominio);
 N   ALTER TABLE ONLY usuarios.tbl_cat_usuario DROP CONSTRAINT tbl_cat_usuario_fk;
       usuarios          vince    false    333    232    3996            �           2606    25752 $   tbl_cat_usuario tbl_cat_usuario_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_cat_usuario
    ADD CONSTRAINT tbl_cat_usuario_fk_1 FOREIGN KEY (id_cat_usuario_categoria) REFERENCES usuarios.tbl_cat_usuario_categoria(id_cat_usuario_categoria);
 P   ALTER TABLE ONLY usuarios.tbl_cat_usuario DROP CONSTRAINT tbl_cat_usuario_fk_1;
       usuarios          vince    false    232    3994    331                       2606    24659 Z   tbl_det_departamento_asignacion_responsable tbl_det_departamento_asignacion_responsable_fk    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_departamento_asignacion_responsable
    ADD CONSTRAINT tbl_det_departamento_asignacion_responsable_fk FOREIGN KEY (id_cat_departamento) REFERENCES usuarios.tbl_cat_departamento(id_cat_departamento);
 �   ALTER TABLE ONLY usuarios.tbl_det_departamento_asignacion_responsable DROP CONSTRAINT tbl_det_departamento_asignacion_responsable_fk;
       usuarios          vince    false    236    3856    299                       2606    24664 \   tbl_det_departamento_asignacion_responsable tbl_det_departamento_asignacion_responsable_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_departamento_asignacion_responsable
    ADD CONSTRAINT tbl_det_departamento_asignacion_responsable_fk_1 FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 �   ALTER TABLE ONLY usuarios.tbl_det_departamento_asignacion_responsable DROP CONSTRAINT tbl_det_departamento_asignacion_responsable_fk_1;
       usuarios          vince    false    3851    232    299                       2606    24649 P   tbl_det_empresa_asignacion_responsable tbl_det_empresa_asignacion_responsable_fk    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_empresa_asignacion_responsable
    ADD CONSTRAINT tbl_det_empresa_asignacion_responsable_fk FOREIGN KEY (id_cat_empresa) REFERENCES usuarios.tbl_cat_empresa(id_cat_empresa);
 |   ALTER TABLE ONLY usuarios.tbl_det_empresa_asignacion_responsable DROP CONSTRAINT tbl_det_empresa_asignacion_responsable_fk;
       usuarios          vince    false    3853    297    234                       2606    24654 R   tbl_det_empresa_asignacion_responsable tbl_det_empresa_asignacion_responsable_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_empresa_asignacion_responsable
    ADD CONSTRAINT tbl_det_empresa_asignacion_responsable_fk_1 FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 ~   ALTER TABLE ONLY usuarios.tbl_det_empresa_asignacion_responsable DROP CONSTRAINT tbl_det_empresa_asignacion_responsable_fk_1;
       usuarios          vince    false    232    297    3851                       2606    24669 N   tbl_det_equipo_asignacion_responsable tbl_det_equipo_asignacion_responsable_fk    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_equipo_asignacion_responsable
    ADD CONSTRAINT tbl_det_equipo_asignacion_responsable_fk FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 z   ALTER TABLE ONLY usuarios.tbl_det_equipo_asignacion_responsable DROP CONSTRAINT tbl_det_equipo_asignacion_responsable_fk;
       usuarios          vince    false    301    3851    232                       2606    24674 P   tbl_det_equipo_asignacion_responsable tbl_det_equipo_asignacion_responsable_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_equipo_asignacion_responsable
    ADD CONSTRAINT tbl_det_equipo_asignacion_responsable_fk_1 FOREIGN KEY (id_cat_equipo) REFERENCES usuarios.tbl_cat_equipo(id_cat_equipo);
 |   ALTER TABLE ONLY usuarios.tbl_det_equipo_asignacion_responsable DROP CONSTRAINT tbl_det_equipo_asignacion_responsable_fk_1;
       usuarios          vince    false    238    3859    301                       2606    24826 D   tbl_det_puesto_asignacion_equipo tbl_det_puesto_asignacion_equipo_fk    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_puesto_asignacion_equipo
    ADD CONSTRAINT tbl_det_puesto_asignacion_equipo_fk FOREIGN KEY (id_cat_puesto) REFERENCES usuarios.tbl_cat_puesto(id_cat_puesto);
 p   ALTER TABLE ONLY usuarios.tbl_det_puesto_asignacion_equipo DROP CONSTRAINT tbl_det_puesto_asignacion_equipo_fk;
       usuarios          vince    false    231    305    3849                       2606    24831 F   tbl_det_puesto_asignacion_equipo tbl_det_puesto_asignacion_equipo_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_puesto_asignacion_equipo
    ADD CONSTRAINT tbl_det_puesto_asignacion_equipo_fk_1 FOREIGN KEY (id_cat_equipo) REFERENCES usuarios.tbl_cat_equipo(id_cat_equipo);
 r   ALTER TABLE ONLY usuarios.tbl_det_puesto_asignacion_equipo DROP CONSTRAINT tbl_det_puesto_asignacion_equipo_fk_1;
       usuarios          vince    false    305    238    3859                       2606    24816 F   tbl_det_usuario_asignacion_puesto tbl_det_usuario_asignacion_puesto_fk    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_puesto
    ADD CONSTRAINT tbl_det_usuario_asignacion_puesto_fk FOREIGN KEY (id_det_puesto_asignacion_equipo) REFERENCES usuarios.tbl_det_puesto_asignacion_equipo(id_det_puesto_asignacion_equipo);
 r   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_puesto DROP CONSTRAINT tbl_det_usuario_asignacion_puesto_fk;
       usuarios          vince    false    305    3957    254                       2606    24821 H   tbl_det_usuario_asignacion_puesto tbl_det_usuario_asignacion_puesto_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_puesto
    ADD CONSTRAINT tbl_det_usuario_asignacion_puesto_fk_1 FOREIGN KEY (id_cat_usuario) REFERENCES usuarios.tbl_cat_usuario(id_cat_usuario);
 t   ALTER TABLE ONLY usuarios.tbl_det_usuario_asignacion_puesto DROP CONSTRAINT tbl_det_usuario_asignacion_puesto_fk_1;
       usuarios          vince    false    232    254    3851            w   "  x���]n1ǟ�S�����y��T �x��q�`��^�޴p�G��;�B+UH)J,9����f�g��d��=ٽڛ������S��D0!����9��L�3&�5c9�_�"b�瑾P�]|�Z!i��fp]��;�5�$�&��h?z��U���Ӫ`5V�? x=$#��`�Q0"8Y�v7�������L�(�d��$��;�7p�;m�i�&K"22�.���:�9Y�n�����OA�}����g��m�g�("��4Aѭ���u�U�[F�1:x�5�6ck�tB��*���%��Ցv�ϡ��Jq����֨�m�0]��;��t�,EĽ�:I�RF�*j���5����̗�s�ڛ,�����ϟ�Roz�/RE���罉]�h��VV{��`�M�z���S��%F����I`s��h��;���;S��3�>؇d%im\�K�J���BRZ�a�U%mm�!�*o��PI�+$4)�=��.��PI��m�!x��ol�[�����졖�gq"�U�m�v0,#����i-�������f��m!]���Dr�ܬ��uA���Z)��^���i�"�_-��0��㣨�� Qp���F� �/��pSjY�o�V�[�C��~��#�������8b`k~]����!���6_U�����;X�$\�p��9R�� �7�]��j�J؝�E^I( �O8K�k�R�������QR^̸�g�y�$�^�� @M7��s���`ʄy��]%~"��Y�MY.EV��u��N&�_t�s\      k   j  x���MN�0FדS��b;��U����b��f�L�H��.P���Na$d֖����f�V�����K$o] 	�TzT���9Yj�Tr����V�>�*�V����7+�[��Yl����{4�΃I�]�?�����P
�\t���ycS����-���CZ���k�z�W��L`��������$w�:�&K>W�Y�&wۤqC�"�aC솏f�^��Sǩ��V�	I>�K�%�#~M�$vԒ�_-a��}�vh�cǖC��܋��{���oܴ0��[����Vpg��|�$:��1�]�����"^ދ��9�a�79�����6��s2����N*)��R͗�Oe��hY<���� iWb�      _      x������ � �      Y   ;   x�3�TP�T0�33�4�37�4�4202�50�54V0��2��2��372�� �=... 	�      g      x������ � �      a   m   x�3�T���L�,ILI�S�Rs2��r�]�uA���ԢD��tqAijqI"�!����������������������	������������!g��!W� �,      ]   >   x�3�tMKM.�,��4�4202�50�54V0��26�2�Գ0�7�24ѳ�4�0����� %��      [   A   x�3��,NTp.�/I�4�4202�50�54V0��22�25�3���25�314���4����� K��      i      x������ � �      u      x������ � �      e   �   x�]��	1г\�6�F���Z��aIH��r&)�D���E¢d��s��喼`e\��x��Su��L�f-�tFI����T/��L����_��]�	�-F�9
�8��G��R�!����]3���70^s��n�-�      c   �   x�}�Mn�0���)r���8~;Tu���@��8(4'�z1���vF��h�|����n0�c�L�)]~�&�D4��p���N1�^�U�����%�Y��8�+��J������[fQ�����Q&%q-p�9�l>�8�����������'��wW6�Y���9}s�p�B��G�Ql%�,����@�Y��ص��^l�^�      m   �  x��[kz����bO��C!�A�����J�����nN[��9�xIKc(��7	7���C�B�'���G�-%��$����w��%ɷ9����&z�0*q%�eq�����Ѝ2B����bμc`���P��O5�(��]�n���o���J[�_Z��֮�L�7�֗���Z|D~���\��Z�]˒�,�YY(? n�D����.Y�c�i[AԞG�_ð}����_˒�T�i!ݨ�#�X�En1�S׍��|�j;�� <=0m,�
�D��~���M)ǯam��W�r=i$$���!�D��5��a�*HI����mg����g�}̩A�D��
��M?B�2V�E�*�t�c�ڤ�׽J�)��-�5�y�bۯ�;[;�;�bx���\p%��ն�'���~�P���A�>~��0H�@�$�.EU-S����U�}u�������O]��B>@�V
f�jY|$�ם��-�5�C��{m�R1?"n����J�Z]+�u��f��7�N�0*,j7�%�R�L��e�.I�����sm~��U���tD��3��E]7�z.��Me6���@/��[e[���Dm����j�	7�$���W��Iǲ�b,9g(W�Z�]��N�>��Zx@�@���d�ó{K���#�/�}efY�Z$`zk9�ٳ�y�>~�����g*1I�¥�}�g�z�\�R5�#��8Ŏb~Y����12���!��şw����(s�0Р�Y{�� +Q#�^��Y�죤4�qٻg���g��X����@	���&���k��S�`'�}W��	���JT��#6�ҝ�~��U>}b��W�����J���Eg�R����o����F��`3�,�J%�;	�|�k�|��0��?�V���t�|Q��J�T�^s����f~�>�_�A@��V�����5�����O�ȋ�v�-s��^�����ht�|���!>���o>1��Hq3k_F{5>R9,{�j�7�p����z�IJ��V"ZH�2�y�x���Fu�V�MYh�u[�>Zj7ޗc�/��ir�?4�u����Q��� ��鳧����u��>ѐpǉ���B+a"�gQ'�V����9l��+O��;1���"�$�W�֏�sl�Gdv:q*7��uL]�X*��1��9Lϣq���h�9c��x%���TVO�������q�W�"gܧ>��Xi�=�[iX\�=h7�P'�Za�o��^�}bj*QV����)���Q�}�:�������TgˣE�Jap�_Β��ڍN�Y��#͐O�6���<�����?�Z�@-�xZFyk�1�Z����{�3�X���ͥ����1�+jymP��y�@���/�<G�_}v(	��74�S�s����Rz��ױ�����I�xӺ�.�U�ى|B���&v�7�SH��"l�4%5�ZS�f?�i�S�����%{cPO�]���k��m0��2_�L�qY�5�D�`�k6[2�y�	����J����(nQC�2��Q�7�(g�Y����4��a��Ә���Ω�,Nw��Q��]>ڞ�iH�X�SgQՉ��2z�f��k�~93�O��۬#�(Y�v����<MӬ����3�2l|>i]��D�#^�Ɣj>j��䗜�9j��Rز�P΃�b��a��	����n!i°�����;f�S��Ó��y���V���x%j:���yӰ%�R���I-�����fcyF���x�8) 9^N �<��@�Έ�
�Na8��������f����\aE>!U2Q_pԔV�7���p��w�Shˏ@�M�ڞE�dm��!$��)��lo��N��A�i8�K9�1���Ab��@	:Ĕ*��X!�S�j]�OX����Z.�<����a|֙��)hT��[*p
ϢFݥ�O��aG��и����EtD.�*�ƍ~B�B�cW4.�$b�1	qU�]G������?��Un �@�Q�َPM�c�#��a�'y��S��ě�c@q�V�"hT�E�a�=,>� �r=.}
`�JÅ%΢�S%�9�������c����L5"��\D=��[�P�e��|�w��J�X��ǝ$-�Q�zպWkV��I]a���(}ix���]v��)��>2�h2���ꕨ�c+���[��j��l.�aR�Xb#�MH�DG�m����%#�N]��c���J�ϧ0����ы�utUE5+���K��5�{`�li�/�Y�z�P����*�Iߏ���cc+>㦼;���_Dm���9ך-ǔϸ�h_:�9bBؘ��D�	�ZQ���i�(�Rtʚ��Rn�����o\�����)-,+Q_��A�Ej��ziA�tHƾ�<D��U���gO~po�i�,V����^ȟ �<�[�"u����x�1��4˿��q�Il�R�VƝEm`�<F�����q�5���;O�.�u�JZ��rup��������w��c%�W�L��T���s�6?H������d��H2�,il�h�%�>��7i���_=��`[��AI�J��"{�5�Vz����!I�߄�M[]��X�Jԗ2[��eO�����{��`h�[���W����x�@@;��8І`��׆�`���d'Ĩ����G#v5��J�ש�a%_]S�5S����t�J�~�d��+Q3����V�Eо�1�`�z9���; 4��8@�u]�WP8��`3�1���$-Lhnl=�R�R���}��s�f޻�A��l�S�=������EL�:������$~�(��N���G���
A����ݤ��#�i6�,���#�Y����z o5:�N�ɲ�g����dK^�RJ�h�E}j�g�׷�S�6�/"}����`�^�BZ�Ϋ�{ �,���޴O!�-w߈��i!�Y�<@���آ���!O R&��+��R�����6�@��8��.��r��j��ύ��v���W��ޡS���8�ȋ�Lz�k����_�.�3���%H���RԳ��v����~�?o�nr      Q   �   x�u�;�0�g�� ��&)�	Y�P��*iA���tA��O������8�{��±�~�NY�\X�����E�uC�}�"X�@K������btmt�x�݇��тT�I���!߄2����Y��Ԛ`�M�.UX�A�'s�0�R������8V��w{�q��&OaS_9g��z�wC      N   �  x�}��n�0@g�+�!DR�Û�/�@����2���D�����t�Щ[W�X/iUi�� Z| �'���Le�36����Z�������KֱX'��"{�E�1q'؊���訣��ۡGLɚg4�K�{�2��闂��U������S���#2r�K����*�E���N���v�Mr*�%�]��U��Q��|�W�n����&�1T�/a/K��P��t����U�:�Q]FY�/r/�f±��1��Hx#���lO?j�Tm�4�k��Τ4ɓE�]y��ގE+uSU���q��fd�^�brco�/���LUiN��(i���d���Ȧ��0G�4�����{FZ�4AZ2� ��%�ީ�k��5f		q��&�^M�j_9���<Ny�$O�dk!�V`�$�ؐ�qpI�N���6��^A����$�2A"y��乵�k)h��ȃ##0���͡B.3϶���\;]_$UU�R�n�J�R�l6	�b����."Ձ��b��{6&�Nw.�.�}��l/S��L�E\���Νw,�����e,�|П�w,��-��Y�'��o��^T�)f�EHs$��\��Yڎ�oA�2�0{�~�h{��#1�<R��Tt=8dvS?�<���ă"#/moK�b߂t-%��l/'9,&���;��T>���2�LgL�_$ӟ~F�ӟ�����F�[?�f�ͤ��>���>뺭�d�E��eJE��nV�5��G�Z����      P   A  x����n�0E��W�2 �o-�]�� hwݨ��Q��N6���c�m����c�cR�#Z���q<��,�@��J�U�;�:m �ʵ�;Fm:�_��a�UJ>Nl<�Sa���N~�z������
w$p��߿?1y�i�4민�H�a�f>�!��K>��i�?pi4����z�z6 ��/�T��^���A����y���V��Ů�D�6�rJkJK��J~��w����gv�p2���]9���f�ͽ#s`Xم�̊�q8>�m>tJ�Ŧk�SމO��{>o���k�S�/y����/�&r���4�U����	�5��:'O��i>rq� ]S��)�ė<xl��g��rzw)A�6��qG�p�kq��y����3�[����2ۮ��Q��2�E�ዝB����Ͼ��#t�l���I���^�%0���*'��߇[wZ,�s�������ĆŅ/��Q�N�pϔ2v��g�JWN�$��#S�X.=c�˰r�K���'n$bg�fV�p�k��cy��,�����~��y�Q9����A񝎒��bx�M�$��:�$�?�����n�m	�<      L   �   x���=n�0�g��@����)K�N���H`�v��W)�q;�@�I���̥�u��g1��m�Fӕ�+�M�p꼶��e���<��q<�8�!>��:P7M���eF���`L�I�*y����`�0$rU"��n�hx��o~&!NXI�u���$-�W�w�ߞ�x-s����*���8����ٞ}�H��$o��Dm���4��m7      H   �   x�u�1�0k�� ��Y��H���va	C����H��������K�hZ]�5e��ӭ�{��lsY_�,�Yzj�-���Z
PG�`����C�_�(@B�cD������`6W�G������]n�z�M�v���/��:q      J   �   x�]�A
�0@���s���d�6ٹp�	�m�bC�R��*�����۶�<=t\p�u�8+j��;���	��P�`]����\yI�D��s����bY�|�ϼ,G^��
�w�}
d}�b�~HuI����ؾ��bk�y��,�      q      x������ � �      o      x������ � �      s      x������ � �      U      x������ � �      S      x������ � �      W      x������ � �      �     x�}�Mn�6���)|���$�9A����c�gd�ӧI͈�E��Q]]]B\^�~}��^�� >zF��rʠ����y[�OH����,������2Y�����h���*�0��x\��������_yj<	s��u[~���]���rEH��ro�����^/�&�$tt^������z"mLB��/'%�V�+)����{X�ل�~[�lv�i�`�+��
pp�x�<je�JɐY�a8�D9Zo���U}gm�$���.�1l~�~z���X� 1�R���8ǐ�XP�^fR:��y����������|�^?��{��	���lG�M�J��cR�ɤ���cH�����oc"��6d�DƆ����h#�<=6oSD�#*Eo���g�ʹ��rA����*�"��5��z�0VA��О>ߛw��&-�Q`>gå�hQA��s�[o}�D�+H������̘u�̎m�)^O��6��>7ܪ@�3e��΋V�R��l��-�"������2���ED	���~�s1�t�R���y��7b8��s}��Mĭ��Zg��qnי��m��N�s�K�y�ŔcE�ܳ���Pi7!�&�mu���<��..R+����-��JNq�{��l���B�$��}>&��g�f1��x�*�Y���0�r�dV���'a��r��'w���|l!É���j��h�m�q�\v�}L;�-n?ڐ�IU��O�����y�p1ZEc���dL�I��x(	�vz�΍��D���#W����q�t�             x��ώ#G����OQЩ�����O���b�Ec03�S��R�t-J�5U%a��Hs�G�[3���Ù��&!)�$��03w��9�Wo~���×�W�����ӗ��?<���/������׏^���۟޿y��o���Up!|�÷.������fc�������O�1o�yx�MH������?~z�\���Ϗo���O~���(|�����ʻ�޾{z�����1F¹�_�12�@޿(#3fczQ[� c�C	��K2�0c�xX� c|��O��=�s=#��9;*�1/Ș�=8��˅��L�%cc�8#d��ב��"�p�o﷌W� "2������[�B��iƒ}z~)l! �1Dvߎ<����'KƝ!&�v�v�9�]( =cp�t�1��qg�92ƙ��C[�wFF�>?`�9���o�! �1@��cL���e�0�z|�����_�Lbg62 l�"�-�E+o���"2#_D?��s3�[,##��0��3�R�q�Gi�战����&�����C�~�h�(��%�u���@�?)!p ta��B�".�߉c�yNޅ���e;�@ �dt���S�Aܺ�!D@�ϰ��ϸ�t��D豇��10��s���e��T�_�$�uL~'�C��9L߈�����	1��L�m�X7��#!F��^0ƑÌ�st���1q �Pu=�2�M6q����1���#�@�!��4�wis�m��rq:B���r �Pz�8�s���잹it>q�$�!�d	cv�%��Y3�ČR��4�2��TF�g�}��'�x6b	4��	��e{i{g1�f|�w^0��2p_���p� ���8g5���������'ܬ� �m~17�^ģ�I��#z�s�y������r�X��;7cH� �f�`\��ƴ����ڒ��^r֚vOf2O8�̎��5�3[�2|Kg�5������qw��3B�������iwƘREy���)沋����:��������,��v�`t=]į�q_���d�6�l��۫xy�jC�;�2#,;�6����;w�Fz@�C!����qg�YI�z �}��ȸ3�,���iN�d��d�9�Yy��� ҋ^ǝA�2.[���#��w����D/�Z��m�Xi�gtyY϶��m�,�AO�o�xζd./��؝�w�cH��D1���s��H^��@;kdl�e�ɇ��=��vܔq�ɒ:z��_��%����q��>ȶ:�q.�gW��O��?���N��ُ��*?寻������?o<$�K
asGn��Ӆ��Q.~��X_u^����p�)��-̈́���c*47�0	�h����O&��&��/��<E�"���Ӕ&,�	�T�<�a7y�B��緦�LQ��O�S���)�����0�m��0����駂S�S��M��S�S�_�����������?��/�	�T�K�w��c����M�L�?�1����ߙ�M)O�?;L���?qB�D� ~M'b\&��)�7��}�x��b�ˁ����3��B��`��5����\�} ����M��������,R����x��]�B/���)PH7Ӵ��~%�]�ǽh<2�%G�&Q�
� �+��t�2�������䌁ǃ}��2���=�oa��%��z>H�Kܬ�߭�kY�d�����OOm����.����¶ߞ.�omVۡ�v�z��R?��m�َS�7?}y��͗w���������ZJ/zi[�ҙ$���b�3����/(`�o�5���9{ؖdm�26��6ȫ��I�Aw����.^a:3b	���M��j� xR �����ײ]�m��k��Xds�(C�w��&|�-�Ŝ��VĒ�N���ݽ��f)_��E�L���rLn+��i���º��~ۼ+��,�S|�.���U)��� 攟{_�g�������s���5�VEl�d�!�͂���VPÔh��)���>%�M�>o���IM�R���m�k��kR�t�K�5g<c�Vxl}�_�u����z�1d��j��������2ˌ�	T_= e����i'z���3!��,�8+oǞ�ꁨX�Ruܞ�����2�\l-�.D�Y�&�+�>b�.Ҡт7^��E��>��ѭ�������(X�$��J��cȎV���H1�}w};�Z^=�B-�󮛌/u/�D��� ��=r��B�Cڰ$s �ߜV)E9M��m�m�5p��VP} Lr�EL��G�P��g�@���5z��@�̡#u�Ѕ�_��N�_^]����&�||�ɴv��y��[�j� Kպy���/˫�`�IR#
�~�Ԩ���(�o�nf=
�û�>�����@�\r�l+�3��X����ߊF��-� �J��g��`�6����G���Ɵ?O��Y��0\��u1��G�%�	�F�Ζ����KLt�{slp�N���v.|�m�����������ۿ��߽}��-f%e�����m_����?���a\i�<�����ˋ��.!_�q�3�rK/ere3ye�Zi�{���Q��*9G�~~C�b���b���Y������=^�.�Lr]��J�8$h��șy�I��4�*�a��^s_G����w�.:zv#3������� =�9qt;����o+:�!�nٷF�){�a�xFܓt_��+X��I֣}L΂���N�4�������g�~���b��#�,}%�#�����e��[�X,��F�����E��x�H�s,����B����4��ò�ϗ"^����-r�� �vd_`�օ.:<C��%a]R�Qf��kЯi"�E��m��g��]�k:�v�S����P�����k��tї��A�D~��ZQuك�T&����ڇ�ٽH�0@:kN�B������f��B��ob�Xr�Ĥkȯ��V��X�IwA�2����7D�F%R<s.��RH��'M!��<��)�׿m ~�	��I����ɿ��}�ߓ�X����	=L|GMX�8a�F~��@A>���{�����-K��(�X�kM+?�e�r2yyH�X�
-��ץ(��R�E�'�'y@�6[*��B��kt��!�rBd3�߂1A���d������k��*��R���A��<�xLg��~��W5�l[(T�>8bWu��M-te�ײ�B�X|�������()�hqb�Qut�@i���tG3�?�Q����p��Kl{4Q�F��`�3��h�߯�g4Tj�@	������ͦ:�4gOᬨ�n�1]ո�e!Q>ɡ/�u�w�Z��cvp�nr��&�w��q�@�����&���n-�i�,��K�xO�nl�[�|Y��2Cv�����F[@l#���Ź��M��Tv���+�5�;c
�	�	���)�154���ߺh!�'����܆���,tU琎�d�wN���[���h��c#�m�b<��4vz��s�W��)'�� �@�\vU�FvG>UWG�0���V[r�gլw�Y��c5���G�������_����)U�W�j�]�xXZ�҃�y)���ʎz��һ�N^Sݠh/�m���bܨ�����x�����|�U�Un0Sd�11�˰-L=;Iw����Edp��h�s��J�l9��}E�nc���r����v�nI���۪u��v�P\�/�t�p����4'�
����2P���p�G�Mu:ʾ�>�ѽ1ߎ7>y�G��r�s�B<�	^ZG���{[���S#��"(E�y�a�1��
n-]ÌHtV�x[o��v�T������ë�B�uЭ�����w�}Vy�ۗn7�r��y���:���N�)���csn{��1�ܼ�ĸ�|j��{5�@��n9�u|�7�-��u�r���\�b!D�/���[,��˃�3$��4�7a._��\��@K�� }*�dy�̮^g_*�K�=�"��<����80��|�	��D� �<*�R��P�'�q�Ks�K�n�1]��4-T7�S��⾻��,4,    �9X(��`��~��B�Y���,�@1n�j g'8�3��f�va�2������z�|5HN�q� _�KoF�T<Ҫ.�gMS�w��]F��b�(u����5X����F��B1�wg�)�4j����_�[a�9^��[��B�k!��B8`�e�q9��6����]�[ȅ�\]��K:yU,Dc9�b$�T�#��}�g�o�ӌu�YXs=�"J;��1�S�+�Kla�M����zl�)A0���y;e����\>k~+ց�|
e�@�mO=�{�K%w=J>�(0��;���x���]�h@mwj���Lٿ�����@j����O��/��ܕQ76�u5�T�>"J	����t����3hOD���/1ݷynl���=G�z�L��/9�t[��%��=_��.�M�������3A�Т�n�!�ܬF�u@n"� v��Z&�8Xms
[Klտ���,���־�%�{�[���e_�jϪX�<���绅.�S]�B'����\�mZH��πp��rk��٬��Q&�|)�
pc�]���o9)X��ϰ���Y�i���%{��=h�é�����H3�S�ZV���|�n��`����<HfC|�ϋos��-�X�'rJ�ɥڀ�[�?�����ݍ`��=NX����r��=|~o�I�{x�}�=>�=>�Ն����y�/(n4���e�)S�s���7v�c};-mJA��b�͒������A��~9�ϑ
����c�l,Aw,����_�y���w��?��H�w�/�$76�����@�3:��C�4b�8�r0�l	S�|�n��h@���@TfG%��y{7И�Q���ԕz����u`�z۫�Λ�Y��+��m���=�2�=���(�	IT�����nl"�����S|�a��xk�Wo?�}�g����lT+�IN�.�k�5R�Q��&��}���7���N7{� }���ݮ^��-��?҂<�F��l���M�D���xv��n\��{���?���x8Ӂ�(���=+�}K���x�[��{��gNs���|'b�e��8��=�&K�z�-���˫�´�-m�a�PҶ����N��z�;6z��R;���A��$�g�-���R�w��u�~�
��ĥ�o����7�߼���k/}u%��%��=���νBWq�)N�m2�R�B�&ܩȞ��$�6	�B�f��K%�6	Ǌ���/�pdw�)B���]�a1ӽќ�`�nmXxV���;��N��� &R��g�<z��pt�� R/�I��8o���_^]���'Y_{�9����݊�����L��W<h�	�<B�V�\�>�ԫ��W<d�IR����ϛD�z}:g#�{E;�Gķ��<���ې<��O2��j��7z��+6�Yv��<Y�Z?^�����r��ӱ�?�W���b�����)�������Û?X���L9���j�ɿz��͏=Io�H�b$}���2�="��`0�ɟ�c��_0�xi"1ef�Lh���cs"4/ye����kڔ���'�h��3�PϷ���0�#)0cA�nv1:f�	��B�������A;M��a���4q���M�i�>L3jYL.䀍�o�ݔ�_.��Ә|0�z*i$�{?�1���PJ��P�����*��Ҩ�7j.�e��19a)E�X�8u������0&'Y�j�,V�S4&'�� ~��3t������䅑$��`�w�4&/�QJ�1 �nL������L\�n��v������p	���k�=��� B7��n(�op�Ar�撠D�f�R?,&�i,�9^�a��7�� {��t���Ҙ��7������c��)����,	�㒀ܰ��cT�>���������+��-@����cZ� opǕ�����n�x�CR���(���_�Ǵ�䓙G4"�?�����I+��+K���צ�m�ܥ�+��+3�)�ݤ��S��*+��/��e�����<�u�ln�1�fY �|w��<�*��������hFe0�Q�L�0��5{$�����؜s09C�	<|BтE��會�2τs&J����9���z�K<��==�s�3d��2��W6F�3��!�@�9s����ᱹg0�C�_u3�����uxl�L�y8S-�(k)�{S�H��9�I3��<6�6�L�����>&56��?�3�\I.u���Z�-X��9��M8���B\�)��p�I�Cv�����2Ð����akl��䓗f� ��}� �&��0 �2F�79ŕ����.[�B�+��O�S���L�8�&?��̔9��w7ق����N���0PM�8��wg��0=x����-4����MB��D��PjLds�Y��t*u�M[`"���5��9)3��-0���f�6S¨,v�`l��l�H, _R��	c�ds����1Ӿ1c�dr��<�l�Ӻ�-���28�>��P��2�_��2�t����1���ʙ�$�xɻ�)���L��a��Q�w���`M�*]�9Rj)Z��xM.�6�Bi�.[@�&,gp����췶hl!��0�pQ2B��n��BB4ya�)R�^����pm5���>�赱��$YM��~�`l�2��p�%����0��'Ik2�ݷ�-zG�'��9����آw�y���c(;�o[�N6O\+�	K�E4i��;�<q��\"B�O��4� �l��H	 ��4��L��B=�C�ۮ��E�d��3��{jl�1�<1-�3�7�֘L�XD�n��(Ajl�1�<�H�Ü�AI�Mc��䉩֚`��ݟ6�-,d�'f�-������l��L��&�����6�-.d�'&�m��W�_�Ԥ1ƅl��L�^:�Ņl��$U�% �}�����H�����֞�t[X�G��9�qԯwn�آB68�
ùM�����1���U.��l�7alA!ܰly?P�s[��+���}�$}<�-���&��[�m���RJr��ds�qJqGK)K���o�}�E�Va�Y�>��3Fl�Uα�n���n��-�6��+] ɝw�ql.آnC���(峥_�Ҧ��`����@q���9a����`aK%���5il^آo�C@ T��MSf�y[��4�����6�)&�E�Vix�7E�y��h�UN�b��r�4����[�!�S���4����Ja�3O����Mc�h��Uߜc�~bӦ1�h�D� 7�@�~hc�H�h�iךK�4aLA
-7����;���5C5�hQ�U/s]GJ=�PA3Zn�R����	c�Ph�I+�P�x�O�k�P}[���ꁭ��L� e��U�ge�݄��'���� �ށRtބ��'����"RR�%�/�EۆRD�9rJu�P�2Z�m&М���0��dQ���mș�.��������E��4R��v�������E�Vi8�ʱ߭�Mc�=���������4��`ѳUin��p��X��,j�JC�a��/,l�؂�E�&����#m�c
![��4��}��D���-:6���3ypJg�&��[Tl���w(>*�M�+��ɖ
�S�;op[��(ꤲ����?�n�,����e��� �ϼ�0��`��UN@B�O�0��`�U�É|K�	c
��G���x�d������p��{[��h��"�E>Wa�8���f�-"X�s��bꗚ7Yl^Ƣ��,�(U	-cl���*{<v1�v��,�9�2�;�K���12Yds"�\��S.�!��e��U)��y�O}i~�,��
�e�l�삱��l��`�s�����b�\mX�p.�'�wal�����0�Z|�/�4al����[Zy���av��+����FZM[`�l�r+}R@6} S���\LX�����kKb)��	a��*�h����$3��B�c��~n�!_�B?�l��¥��[`�!k�J�Z�.U�\�Y¥'���[�S�s+��2�'����ح���Z�R'��6$c�=�~n��B�J�A��0P    f���l+�-�P�s�r9:}�}ƖI�����+J����'U?��`�����h�؂�*�[a0�2(��6�T��C�&� �����*�[ax����p_�;���j�V��(i��3JU:��D3�����IU�-0�NXJ}��`�]T�sM��癜�n?6�U�s�F��D�J��6�-<�ҹ��sr�\T�5M[|R�s+&����{l��j�9�A_�^[�R�s+����J��&�-D�ڹ��r�~Qw���T��JCr�S��.[�R�sM�*�DʦF���T��J��IJ�{���T��JÓK�+�Xm[�R�sH�K
I����n��xn����-`��u�QU=�Ҁ��,�	E���T��J#'�RL��q,N�깅&�t������4�8���V��w|�+��8���Vę�M�҆��)U<�,G������[h�)x�����T��BSd%�'ʚ�{,L����Ɨ!��kcS��n��[���~�6�-L�
��E��EID�AUBWi�WKż=~�$;t��&H1�~ǘ&�-d��eo�����4alS�Э0��� J/�&�-`��F!���[?M[�Tt���nR·k��¥*�[a��.;�~�ׄ��KU?���"�4�-Z��X�%�K�;;�B�zna�Q	}�n���I�έ,$B�\�k�-[�&U:��������&xMS�&U9��x9�].�S�&U7��$Y�D��7Ԡ�T��B#��_5�hҘB����F$̹('�iL��T��J�R����q�E+�¹F�ssRj$�4��D�r��x'�HYƎѨҹ�&�YfO�mS�$U;��ȱ�P��|�K�xn�5 y���&�-D�깅Fn����}��ƒ*�[i8�+9:M`3�6�T��Jx�MA�դ��)U@�Ѐl� 4����#maJU�-4(�&�┶ M[�R%t+��fG��}�&�-L���&$�7	��-[�R%t+��Nt�n�-[dP%t+�9����o��"�*�[hH��b���4�ȠJ�V��
)�b�4�ȠJ�V9�1j]�4�Ƞ*�V�3z��p��TE�BS�<B�9n��AU�-4�֤:���������F:�g��hl�A��-4E��$鯶���"�*�[i���_��Z]#UEWi�s�\��ũ��5Ret+���k��/�4�Ƞ��V�S��o=Jc���J�S
��4�8�J�V�7bTj8�4�8�j�V΋�ˎ��㔪�[i��7�^�g�S��n�	u#j�cm��n��.��7��E5O"��)UQ����cH�\�Ic�S��n�����Z�1�"�TM�J��3�Lʪ@���TQ�B��9a�J�j���TY�J���]m>Բ�T]�J#�C��6�-2�º���L>�Ғ�Ic���n�IR6�aDk=Դ���V�܁�6�7������+�O'@��E�m%�����4�����Rd���hB?�;�,��
#;�`�W��	�d�U��SVKƎ�&���ȹ6�ڄ@y瘱��������������ȩ��R�ٱS��"��0RNR
�����MQ��fI@@J��I6v�7YDu��Άc�2v�7YDu��ar�R��I�$���߽�|�O��>}y������?=~~������>���������_^����?����w�����d��|�
9��8��O�B���y
%�S^w�� �3M@�O���O���������ͅ�O�~'����ĉ�?����|x�������l#i���o]���o�GL��O�G�����įO��S�ptxb}R���#Ӕ��-�s�;��-��U�P�j�ΐ�*$9}�+c�����=Nb�"���&_�����$X�?�/k��F���(�?�T�@�k;%�C'6X��M^,�o�_IS���;�/�GF�\9��T����ٰ0����\�����)��ʋ����ذ�_�嗊X����l#��`#��B�
��?E�v���&o�?;L<�x��j~.GYL)�	���~�-r���;��z����㻏��z�V3H+L��r����ƯB��(Ґ���VJR�lǯO4QZ
�ȗn�IV�\��r o_[;|���H
��ttʑ���!;���Iz�}��JΊ�+*�_�?���21�3��rPXƎV��m�Mֶ�ͽ���{`�5�*�M�TIDhnΐ�����Ea�>�*�]hj� 1h�)c���� �
Ӏ�_T?�}#��d?�fT��D����=ٿ��n��N���)ǿ�y�s'^���ң������H�%I��|�g甓�[���leE�C�#B���_��r'M���������&�m�R%���ɩ�@ƶr�i�0Eze@���f�$�LHRv��h��N�fRB�&�,�����;ze�ȴ�,-N0��>������,�5Y����FY�=����﫚.ø
S0��䀥M��9��f��0�{e�	��3�� %(�*o&�X&�>�[}�&E>��ۛ]��?u`p kJ�#�h'=���fҔ�Gi�)w�K�&M�|���LY��]0��JS"aB��OY[��TӔ�G��!쌓�M5M�|�I�,'����VF���;R��tl��v�4%���L<���Q���X����5aLSۨI��0(�^cTZ 6`l+[Q�"a��.+q[0��ƨi�0����7v	�	c�n��y��z2��9�3E��i�,U '���K,Fa��R�ÿ��[4���D����ip1*G��&�iԄ����.�q��l2�9`ء�R �rol�5����iUNP��/Xj��ɐ�?:H Or�ǉ��FM����Fk��K���4��5��$iI.����Eք1%z��A��U�L�����b���v�T �����nՄ1%z��@^���V9����!�0��*��+�dS���&�-��+~�]C�8��ٮ]C[:���0�M*�>A�/�6al�L_��`U��9b��||06��G��þ�k�.]���Hk6�3e��?��R�F��s,ұ��61b_�{
g�	����JQ�}�0A��\(^i�?�R�:�S����2��x_�{
�f, �R��t���=��n����[)�}��)���)e�-�ľ��&�E��`l1�/�=�)s�����
�� ��^r=�/�=���D����	D_�{
�a���������w�I�?�D��0C}fb_�{�iN�|��(����Y*�1�e�M[��k{Oa
ÀrY�(����3H�\?�����S�����<>�~'���'0�����AM[���zOah���~s�&�-P�e��0I���ʡ�;���=��Sp�S�}W�(���S�)����uމ}M�){`�2���P�ؗ�����
�~;�&�-P�%�G���%P�r`)�19a9��'�\���t�����^	�;�	{tؗ��hNd�\:@:v�>��NM[���ad3cf�o�7al����=�d99)xG�ʢ&�-p�5�'0^� �o85al����=���QA]al��w_ӻ�ԭ8�g�J�`7������0r��F��09��a(���z�<Rm:眕ڌ���0���O��5N��e�G9���N�/{`l)V���f92ι��5YlV��L���Ɗ����9���86���y��rs���������<"��Ai�58���yCevH�T]�M+�Gea@�r��)ea4���,E�B{'O�P�?(�F�8@�Pdl��?'s���S*����26��1�G�� �\K���J�	�MٕүZ�2&,��0�X�R<�����tl�h�Ɩ"���#L���T�b�����	�'0�r�Wwp%�>�e�8!B�?��JD_�v�C�S��o��8����Vr2q
���+cLg�2�SY�wI[��3}�	L Ig�rt�X:ӗ����9rn�o�ʘA�eh'0r�w�;��mC��B;a�
io��}����έm�1�_����j�`B_�v#�8H���ز���FN�H��E��}�)��xx�ﻛl�L_�v���@� �  O�U �eh�0'��I��}�	�f\RZ�V �eh�0<�s)�hB_�v#B� �ߠf��/C[`�4��=R�I�;���N`@��r�ܷ�g�M}�&ɴ}�~1�wЗ���Ȧ(�������
턅dg\?4n�UhG�,K)߿�ƶR_�v�)UR�	�¯���W�����92A���؂t��V	My�(禌�H��
�SK����o�߂���ԗ�aj�T�r�+�0�Д�2��<��r�C��R_�v�1S �뮣0\�����J���1x`Y�[*Y����54�ԗ��C�*/�p%gP���`�2�
#GB-��1�ϭ�ΗM}�j��8#�؋&�)j��M\u=C�v�T��de�@פ��r�QF	�N�	�7flQ[���C���3�lp� դ���sa����-P�2��uv��/Ck��R�y�dޟbF�"x��h8ר-}��KQ�p��+M�&.�p��W���~��*��k�4�v\;nh�1���J�N�V��Jg�6�i�Ta�BSO�>��O��Te�BS7)C,��9�ȘTi�BSK��䤜ߤ�Uw��<��Tb�-*��|�B�0�$סeƤ��Z`"��Em�'V�qG�8�DE;?kh�1����P�yK�s�>n���F�I;�kh�1��\;CV�)�����zm��iD�4����hջ��ϤJ�*��M�G)�Ϥj�4YN+ݶ6�؂�*�[i�g��r�-~&U$w��\+kG��<q��0�};�-~�"�#���i^�hl�[U�U� ��������4������ڇ6�.��J�c�ߪL.ZgʺZ*�Y}ck��L.zM������ǖbU���RO��%����1@�2�J��Q��EiN���1PI�=_�R/��>X�s���/zmn���ZR�ý��U�\5�,ɺ9� ��kJ�T�\��u1�d���w��
3�*�[h�,Ug�a�K��4�,KU�i"� *S�&�-�R�r+�3:R|_ƖبR�#L�SqQ9��Ic�lT��J#�rжu�4��F�U��l�ƒ��6�-�Q�r+�����NKi4O��pB�C��Ն��Y�V�������w�4�DK�-4�6����Ec�Zn��J	�J��6�-��r�#��a�R`ަ�pU0��Ԟ g�*�:P)����F��%��	m[�T%sG�'\Qd�m[�T5s+��|Fe�`l1S��ad���|�al!S�̭0<]H����-[�TEsGi����؂���[i��>��wۢ�*�;�H�=���ަ�E)U7w�)s�th���*�[h�l��]��q���T�ܑ&��R��C�ilQJ�ΕC��s!���lj�6nR�tn��v,���D��T���jWX�X�cQ�v�SdM+�[�0��j�V�����"�0��j�0q.J�:�	c�P�v�S�D����-@�ڹ�Ӛ���ܨc�O�v���/Av�nm[xR�s+��/c��%h���*�;��P�5al�I�ax�[���ׄ��&U<��$�u,�|�7	�p���I�-0�`Re��T��&�sr�fj��b�*�[a��l��/�k��b�*�;�ȩSY
����b�*�[aD<�W�lZ��T���f�L�Pl�I��QD ����ӄ�E&U:���Z��"�}#��T����oL���Ѐ1F&U:��H�HHJ��&�-2�ҹ#���_�k��"���+�
�H}�w��ۨ��"���[aD!�Q�u7aL�)�ڹ#Ϛ�tb�c�LY��aʜKv�܄1E��j�*�w�,���������[adq:�+6�0�ȔU����D�̸�����[aB=���	c�MY��a��,S� lbSV�s+�2Z�~c��-6eU;w�)s�P�>Slʪvn��}c�7IhbSV�sɚ}p1(�M��eU;����D��bM�tna�����t��0&j[�B^)��2������O�}�O��>}y������?=~~������>���������_^���?||�����Ow�TkE��+tSz���U:0����{xEX�*��~�����)h|�b�ys�i{�AH0�����'M!��<��)�;~�	���&�-�3�{<?�w2�/�{2�7�?���s�	�'�����E~���=��?O^�e��'~�[��<�[��<��䁅?a"ǟ5�������#�X�T������4e��3�������d��W�@�
}�J�(a=���M�h{1����|j2~}Qӫ?�A�߾jJ��|c��O��?���N��ُ�_+?����K������WO�rX�	��-o|��'/��??<~z󾢗�Gy�AN����z���OA����o�ן��3��3\���.^�k�~ ����7���ӟ>y���_/ҏ�>\��w����?}�a�Û��.�������_�������|���-_�������������?�ÿ��P�3��[�a���OOoٞ?<}s�����@��ۧO���P�@�u�a?f�&m�^�6��b���E�O��>�C=}xz��~ɇ��<L?>}����w�o���|��s0���[�W�C=.�3{�ʙ�/t�p ���w�1��`����Pr�q�1�.]�?<��I�-�y�{8ոx���}5g�s���4��O������N����®�]���?��IN\J���W�S�F�}m�Q.^�&�|�'	�}��5�5�?�����h���?�ș�|�������G��A�S��[58Y��}YT������E%z�T�F"\v /;�v�#?�$����_nx�컢�W�8�K�����&��p���y�=�&̓x��l�Q����/���U�Q�K7�/3���#�Ȏ�p�د�Dѹc�׿@:`K�
�t#�w���'��D6C��5(p��+~����<�:(�8��w�������      (   �   x�uбJA��:y
_��$�d2�����6ޱ��y+랠O�����_�10ܝ�y!�ˎ↣����;�����p�7�z��\3dx|�W�Q"-N��y<�G���l�Z�����j�4��I�@���y�@J�xH.X�tt�BƉ�-���ײR�(w��+Tx>�q��O�%�JD���|\.��ߪYk2C�i�����X��"�n��5j�rq&�ׄ�!�d�      �      x��}k�7����)b��I��h�ek3CQ�j��l��l�d�� �RUFMf%���Ügl��+�;"2p��kl��$}� ��ᩃ��R����)��c!�I{�������kۂ���x3u��g���q?ǟ����C���ix���?	|�R��*��kA����8^�ñ{���~��z��~���ӻ��j?W��U���{���{>M������t3BW<v�V��ztоɋ���O�S�W��V���tw��>�إ����������a?��߮���%�(�7L�!��۟�m�?���Ͱ�N�����ḟ~������t���4�7����ǈ�s�>��k+�5-H^��Ǜa�HG�<�FgM/�u���C��O�~?�l��q�~7��p'J�s�K�h�w���!y�,�񗡻;��W��������χq�i���o���.������+4�@�Vf�_*�'l(F*���?u�����@=�n���۟�>�G���ݏ��,�7ǻ���=��`%G�Y[(���R����TB�x�Z�yB'å�)��F�&$/���v���������t�}u=mp4w�q�Y��K/��utљt62/��n1,��y�@��ZzՄμ������t}=�OM�#v@"5Nc��(ׂ�&��������h�`[���E�iA��.���߀�������B�*�l��avI��^�N�Kapv�PR��xPܭ�o�㴒��R5�Ģ�閲��R�K�{%�
�-sQLD�#4��,���J4!���T����{
f�����n�����t�o���[�%#L�a{���$/�]oo��a�m����1��p;n��5�����p�F���	87a}��nA���4�.g��������5�����Zn{-�����X������X寧���8^��AC3�W�����?��v���_�������&����-��g��O�ӿ��F�K�hm���8ǵ �N~m��n{����~�u5��n�������#�[~���|0�����3�֓O y���L}�s����O�����v��ǫ��_���a辈��/юo7��0�?vo��w~���a7|qf�^>2R�f,Dꅄ�TB�!��:�9���=��MH^�|���O��q�Ǵ���G��VT��ե᜶��n�p:N�N7ȕ2� y�X����۸�\[���3`O��v�����<C Z�v�3�������O��9��`��g��8܀���s�ц��ҽ�N�&��g��=7��I�oA��s�Vu�lDfͩ����A�oA�ƞ��j��j���=$/����	l(��W�|u E����Vc�U0��R�ܨ��ُ�!�_������k0�K`�v��q���c�!G�%XGF4B��
kC:�e�����Na����*����ݵ�3�w�~܎�=9��q��I`X���kBg��0�`D�o��&��������������v�����c�i{5�����t�����C�o`@��K�6��Z�
�B�#ųNƟ�T�Ǉ>(!\lA��9�?�}4�����b���FV9dlA���	rl�mrL�҄^@DM�o��;����D�Nx�4���֎iA�(t_��:�n'�Z~	��Mp���t��!֖Ƶ y�·���W�����t�( kfJ�Q�ňƷ y��j���@�q?܁O9�)�;l0ʜv]�i��PjF���u&���H*���>��Nr�t��Z������r�u�[k!NlA�:0iV;�?��`@;[�L� Ok�j�i4����y�TB���I�}�yո��Z�PLB!s>��1��R�vEv�!���7>tȼV&� ��b���r:-p/�{)�A��A������H�K�>���,�6��
e���CH��2-��z������!l�T}h ޔ����B-$�E�C��9-z����&R>phx�=7a1��I��Ip����Y<5���	A�~{�wnA�>J�z�	���f�4��8�
����#����h+*%�Z�	��Lgl<Ƙ��N�4�$�YgmC�AN�m�2��R>l^-��&��&b�>�G�@B�r�l�+�88~�KgJ d~�w5<��#؏{Q�*����}�m�8l��:���7!6������[�&$!��)���ʹU���֔���I�bYL���#�g�����@�����ƚ��!�4Q�Ja륮�FHn�F��Az[,��˞l�\�5�\�U`<[R>l��M��p���>S�sa��P��Y��4,x�]�3��$ʝO�*C������!�|�P�;򹉀��I)�!�����r5��a��F�iAxa��Z�o/r����؂��n�]�uK�+�qot���-Y���әY�Q���M"C�>F�5%F�������������An�)�kr�[R���k�6�+ϣs�nE֐�$<�5�;��Yio�mAH�t��gSwp���µ �I��kZ7ˁ��;���Lg���E:�� ���}r=캟��_�����n�=t
����XGٽ9~NG;�2ݽ�{��x�(��Z(#=�YC؏g���]����]��ӕ���o���~�m�C7�@�7��:�a�����=�_LGS'����̉���!���;�'���a�^B��7o���Þ���Ѫ�k� �&4!l��o	�:)Z`�۵��6�7��M�H��5݈Uڒ�J����*C l�ۻ�O'�����iH5r���_�+�@��ӏ����?{�"�6lVpr!���5��)!m�pGu��_ƛ���?wr�L�s{�-ފ�� v���P�>�������]|�}3�����i|����E�+5yiL�`���:"��dj�{�Sx��؄� )Kk�Q^���
A��;G�&�P��$L��۵�!R2]������#�1|�	IC�I��lKr��|���[R��M�u��Ⅸ�Q�ܚ�@ҐC���(�0��͠)(s)���bv��M�S�\.�l�}�3�����P�CH�t�v�&���?�B�Z2?l7k'�؄����-[���Y��`敳����t>�N	���^8��C��D�����嬇��ӂ���G+����QziT�{��}G��*\�K��d�!i<��cp�x�Q�l��*!pԄ�״YmXk�j�&J^�Nr�!c���K)���,��CT��.� ��]�IH
](��CH�t3)R�#wW�WJ�_iA��_J����{/��D�J��,���x?��\��n��d1�2=�v���<���t'I��>�&�?{�a%��3�ŝ8qTZz~܎����-����R��T�ģ�3���b��SB�0��b|g�ύ�U�u�-haⷿ��1R¼��]�6��V���YΠ��m�B�R[dU�8�/���e̕�������y�ƻ͢��V�i�"�wVy��.!%3"}Cq��@Pt6��ͣ�x�6˅t��M-HZC(e��ә�$�B���z�_��5�P!u��A�S���uj��#�$;����V|��=��_K�>�s��ҧ+���4n�D	$-�jn��`n��b������CV�F��a�{�jm-�����~�@���j�⾗^�^
����̬���׶�6!iI@�jr�H�G-�!�!�l�c]d}��	��R�����D��L�Y.b�D������!�,�M7�)�K�[�]�&$�=+�W'9�;3i���)�XW�*�t�|j%�iA�3U%��!�ŧ���D��t����V�t�I8�٪�%q������ o�USU��ቧPQ:�@�#~��uC�"UX�?+)fQ+iT�&`+�06� l��MU3��a:q��\I���+)S'q�཈�=���lT53����?�z�)[��_��y\�~%�%�C��l���l�3q!���37�q�F�,�P�b��P[�d�X�&���i�-Ex���Zk+�#��i[��i/DTż�R>l,;7qO    ;�
3�C�z�oW����x�1V��&P��ӻ�q��� �(��F��(�) 8Vn��	�����J��I��`N�.z�Cґ��6��JKEB�&
�BJ��/�g���v^���!�I�a^���RB��#H�t�����(T\/=�˰���z:���!��"W�%��egS�S��������[��ds]�]��,�S��ҵ$d�Zݍ&iX�ZUh��'ыkxL���fӯ��V��$~��#�r��b�D1U9����7%��k3R|IO�{�A�t�̩��k���BJ��'�7�x�#�^��xu�_u�%OZ�^�hK�Bʲ��̣�8��c���27ܫo�I�堵5M���=3)�Ѽ�!%3Mq�?SFs����$�7f�w1X��$R2�m�1���m�o���64�̯��kM#������a) �4ʭ�VR2ߟ�w�2��^��*��%hlJ�)k[��ˈG�E�s�Y>u��װl���p��B�W���X���w/��z�_�nǛ۩;��as��o���v�/�����p�O�Si�u.�5���B�a���0q�@|u�m!Q.'����ų�d 5��Q��2���16!����K� ��-����d �/����IO���-	�^c� h��)>'�d ���y� �`�#�iA2xU=����=6��C	!���b\M{$���pz���\4y�UB`��~�i7E��pz�ڹ���%����G,�2�G,�r?l�����1q��px>_<A��y���q�ݠ�����ΔW��1�֒�%���tIY�TD���_C�C��x�()(E�%%�L�Y���*��C�(�	��0���̜b 9�kL	a�������\�<�����+����1���v�U1ϲd ���slf9����KY�H|wd5�p��$�&�l$c�$�`����:B�Y
-)���f��=>�Z��*](%���K4[�v*[0}�r|G�ɓ��+X�3A���\'$k�<T'r�.���Wl|�Q�)�)��/��N� �|�R{��v����4��i?n�"#4��	>��	!�(��r�:UI�-֧Q��๧2��Rf>���V�)�2���$���������7�n���j�~YEEl�RƎ^�3��J���a�_��Ջ����	�x����<6�%��Wb $���ƪ��e?�Qj=�J�h�c���w��8u?n7�x���lx��yj�z0���Oȡ�����f{�L���������f�i��o��`����2��C���6�N6�ݢ��5l��Z_$c�:>h�Â/)��4!d��g1������!�l����>+���������p���SK�
�@2:BYu�������."���5����cq@�ۢ	aY��z���~;,u��t��qk]��sH�<�v��[���뭈������kN�ҽt{e���P
	B�ҵ��4޹b�Q�7|ѥ�l ����k�P6<�M�"��G��.�Ps��-b�k�1�l�����0��(�B����8(�0�ަRv����
�pw�	��*�f!b#�ĜE.�� ��UP^@D��ĜE��&H�Vc[@�5|Z�=�R��P$��j[�K'���H��|6�"f�*U���	�V��U�K�VL���b=H6uOWuo�xl1��D���������A�"��骟S�SL�M�H Iբ�i�Z���9M��C��8g9������#�$+�4��8L�5��PH����I7g���,:M RP͙��i����>ցB�R���kևw���ko�Yw� @���Β�	�4L�;����	)�ↂ�D#��m���r|ݡE�a�#���z8�M�ϜY�9�DKR�P�Ϥ��	�fe�kcF!R-��3�\�#C�m�/)Dj9��н�IF�Q�C*�VDJ�)ʲ/<x��vU�&H��T���i1gype�y��>�B���RZw9�ԅ����b�����v&�������6��PŪK���xRh&�*�N1r���2�k�TEr��XI��%5�9(��g��y4>�y�("U�_�g���x���nBZ�gN�\�,%�&���4��(,*_��x�=�8m����㸙��Wu~�^��֩6��_��9>Qf�Sz����"Ր�(���Mcomq=>��r���'�X�#�&D
9>cf�K?{c��F5!R���U{�rX3C2��I`���9�Y�U1�9����UU�`6�ģL��Ha�g̜��E�\b"�o_�g��io��"6!����E{�T��8Q�0��ft�'���D0�V�6D
�8�v�"���u��X�"�*�1�lzSR5!�}�2�A����3f�r�����"���uJ?oE����H��y7h��_���thB�i�<�k'�!݆H���ϳ��X	6@�A���p�σY�dJ��Ve5	9�;p|̽��a���h��`�y1g|��d^q��1�|^�"���`�m�}g R����f9���}^��AH)�'���0"q*�bA��Rp|��"gSQ+���$�!�z`�BK����G�,c�j�O}9�a�Oo��Tkp|řE�c��PY���"_z��A<�2m9"�_z�,1��]�Z�W`M��af(���0��̓�J�ˉ�(05B�Ɠ@䡾���^.��΂)�����#��ǈAT�A�Byd�n��(s���S��rdD���Z2Ց������!�U$)$K�Ӝ9,`�ċb�	dk�^p��3E�ŠŵQ��?�l��a����Z�4�}�x�8]�E�|J����A��U�B���,
���6]���~��"|%�f��(���P��H�_I������C��;p�׸9�`��R�AH/�*���">�Y�" ^4��'ǸPt�@�%�g��Z���k7D!��Ǟ/c��t�,�-�'��cy/�]�I��G��e��|	�3���z�Q�<�����Y.ݼ��RQ�<h���YΧ,H#�G@Dބ�J�,���ǥ,�H
9E(��j�5�-�(��sp_IY�K�8VՕZ����y��|��h.ə�f���
@!���J��JV�])I�Gت���P�����������RESx
���!�Ė5�$>,"{
��վ��2���C�ux��8QȵR|%���Z��*���j_It��"f�{�5�P�J�˙�(��	"��=_�f������[�(�\ӤV_N<X�I8S�T
�w���u-��2��02���QȵvQ^5Ԧ0�)WXĵ.4|%�L�۹P(�ȋc���˘�kD/�+븆�3����n�<��~y�5q�����c��he�]��B^��J�,��%L�H �:򕴘3O�(��k�<��|��E.��`�W!�"�o��J�/b�Պ2/6�A�����}k �
�ߺ��|�'���͓�y�{���p��ƛ��_vݫg?u?��go��/�ܽ����7O޼��{��_~x��_�t�!�a��lpp�"�c�������8��Y� ��߹KI8�/�.��R�b9��f�)������D��oB��Ӵ�z��Ez�����4!��SYK	߾P'�"��$�?���LG3���>��/<�)0�Ӆ�vh����T���'�Z�)Ls=����j��5�E�ځʯ�B���k�,r�����
��P󵷯�ۜx`b��z�R�����t�Y.��Jo�z�B^d{�G���QcL�14!����l���"ίSCȣ"o�}%��$�RM���%B^f{�{̓����#�@�	����Lr2չ��JՆ�`oy�y��?�(�Ph�����q�y`; �v=Y"����O_Or���!=];��k���OcL�@�<b���w��=8#m"�}%��$����]"�}%��-o�!Le��D���J��,���Q"	�Dޛz���Y��YT:4!���ef9��ZwXV�	��%��dϜx`	�J�u�)[վ�Ms��}p��GoD�z��:�"��}�U�T�ͭE%���;��   bt�*��b��W�kN<`p%Ҧ	�g���]s��J�[�_kiC����+�5'�y�"���A乚���̿\fЗ	|lC��E�+Ҝy�|�v��py�+�5n�b:��Ϋ&�|�+6'�eG���	�7q��a3�Ᏼ��%�6D���J�M��Od����&D^�yϿ������J��kE_s��l����ެ��B䱚�U͋)S��Z9�SE��Jb��l�؝�}\�D�_BU�b��u}4騄4y`�+�5��q�%�hB�<��ԚY�brK0�d)���N&�0�>�ā��L�E��|�s�6�$����0%WVl$�;��t���Θ���(Q��t�ՠ�$�$|,1c#H߂0���ab�����ʸ���jl�S�	����K�~����l�ŚV�r�{�򞡼���a�+I1g��c1�)�!M�JR�,�
�b�-z�C��T��?�t�x��=� M�5�J�,���A�&�1ı�f9|��5y�^B��c�����z��dʘblsH������r���fB�(ϐn�d���0�!�����\9�%1ŕ4��g�ڑ C��k)O����x3�� ��3̷�R\-(��0_Nw�����Ԁl4�~B����5��)�`�b�H7uV��B����W��H
茰�	��{��?���M���􍼺��	�ηY�m�2߱�Jʋ?=��x�B�6��&�aCJz)��,'�!G)�(!�.`������|y��PB�<�\��z�d:eK'A>�of!-s�����G��?E��      �   #  x��X�n��}���y�Abb� }�m%�i��S����ج%� �8>�v�O�/t)E4o�I^�Y�={־���2�f�ݠs�D����2%b�N9?c�LP�h d���3_1w����4��4.�*�Z��]��̑\s�g ,����)��4K�X nǹU@�0-���@X�({NL��P/��Kx�bT������+Ty�~}n��y�Q�s��%��a�jm��_o���t�LQ�.zz��**�֯�Ǣ(�9݀iGh���?;�P�P��VZo��~c�E�2N������G3���DZ6�����)�(;��P7�~@=�s�me5a&��?���ۜ:`%j�L���@T���+�����7a��:��m�5���IZE&&�v�CLåo�8��<{SF[���x8�A����S"��x�]3��C�=��h����x@�#��?a�m���Uosߡ����0���p�$Aj��ށ0g�������_���eG~׻z����*`�2xt���9G7Q���?M�J������`.��h[gq��e�9��m�X+��s��j�a�
	��8A�R2o`����i{���Oߓl���`H&�4��6����CNjS�Z�����e�O��.z���vwVdu^�f�g3����#�!o�>�^���6/�^?"��Q.�ҟ�0�Qh�2~��+�-n^�

ΜF��h��b��go��x�2g�p9��C۪���֋<3�ӿ��_F"���2��2�Ii�y����@Z��t ,8��צ��f�������Bsg ,�_D ����<J������u��-��w�>�'��!���k�%�;�r)S3��QY�L��N͔��bs�Z�fp��x��.��F����� ��;�ᡍN�D~�M� %�N���iC��wW�$����%i޺ʮ�KX$a�:�	�p��J�g ��V&�7������A�R�qڅ0T��������M/����)�9�hj���K�@XR���[��3	c�� �K7�)	w�i�K��뿃`���"�d�V����X!q+O���0�ě���i�
+I=WӁ���
E�{=�&3�k�q�ߧ�ke		?�/?�	�o��@�?s��a)����[=z�Lί��H�L_�:"X*��Ƨy
���ʇ�u���Tkjڱ;�Z��ڡ@ؘ����9C.]����e�T��cS�����)$č�k�{�� �@��m���k�jm;����3�H���U�&�����Oru�����2��VEɷ�o�%-�Tq�e��d�_'���]�ȵͫ�Bpg �j����,)�4�̑���昦�;� X��,ݝ��h_���w��^"X	�$���f��nV�"�MT��-	�����yt�͸TsV]����jߍ��υ!���*�@�䣉�K�{�����fO[]Gw�l�e�S�/�.��ȓ6���V�h��b����6����v\)]&g �4
�f3R��f��`tl�M��턡�f�9��rQֶR�^u�W����<#�c�G�+� �0s��撚&�Y5*2�g ���l>7���5I�}�<}�0.��l�)@('�Q���4 ���Ԭ!�5CO��IQ�6A������U�3��Irojr�{ �v�~GΘ�������Bw<?�0��թ�b����ABM�jut���e�p+xI�$3��������;W�y�VJ+.<���d��6[r�lY������÷J@��g �s�F�����ޙ7��5�}<��3�z~g�R��,�õ7����6�(��hs�J�eM�����	�\�������߀�8�      B      x�����8���d�8p3H࣍X�; %Hԧ���(d�/oP�W�R�R���?)�I�G�M��߶,#�?��j���_��+���_���T����e�/��2�����u|�" ���� 8w�5`�!�l�y�����_�-�|�b ���� 8��|͸������T���WT�z��%��F�ҁ����p��'��w���o0໎�S(�K�ˣfږ:������Wl�Ӑ�N`�kՖZ�'��t�������A}�q �+�mZ���L��[֚���Zw��t��Ŕߐ����p�!�I:���t��R�)�X�V�ڏuU`�_�k�G��c����N�r˰c�Z���ek]	�+_���U����$���&�Q�t����`2�J����a���O=ⅳ����0׶ҁ�����c6`��֝�ˡ3�9�R�c�R���=����`�]}����]��X���b���X���=.��^?�*��?)ӵ�
�D�a��+`����k���z�upi:�6�ɸ"�`g\i!�.�)%	+-ƫ�Kncr��	��{尹�mƁt�ܶXٸm1Q��+��X� ^�y5�jQv�כ(G� \ok-�%���y�8ceh
�� ���7���O9nr�@9�=`�W�(�������`��mo�7��^�/����L�wX��5_�K�/�-t����o�7U��$X���y�sͣE�j"�^�� �_,k������A:$]LZ�����$<�
L���XX^�W�E	�T�Z��C�m�����$���d�j��L��<��G^�+?��H:�D����C=Y풶��"饄�C�<�I[�qM��o�="��78g� ,��m��:h2F|�������/s��|"��͸�6��\0���K�q�~˗D�)���Q�t�܀��gV����T��Q&�zc��zzuZ)�H�8ϒYȏ5�۔�6yt�'���7YEŬ��m��$rcY*i�x2�u���)���4�Z~�`��o�T~��tH��,��\��5HZ�ǟ�m��mS�����d�!#r�����<��z�L���^�������D�/�Q�m�ۺ�������W�������Rb��<��=�7IK��\]��t�K���U���._wi�g|�=��H:�me�v�Z��t�]�a��������r�%�KclrG�����Ү]aUjRx��/�r4����hq�=���<Z�tT�GK��_D�[N���a�H�����Y��MG�QoLK��y�S�����j*����3̈́�ʵwـ�7A���nJ�9.���a�tK����C�>6�@:�o��k�8��K��U3w}��� ���az{�ut��C���]
��޸�
��'l�����L�ç�^hO���цHG������G+���	��L�K�No��� ��F��L���mƐ>�s	w8��~XO�8��q�C��Y��d�t�����n2�6ծ��	����ٕj���`���b���y>��t�� qS��}$�� ś���ݔ��[<�B�/�i+��F��Q!j�ݦ�g lr���gX���֚��$='���&F���Ky���U����L�J�?p*�Mo�Yy��6�o�G$M"�ʼdob͉��J���1M5�T��kQI1�?�S��ƶT�-��˺V/}OӦ��T>�P��y?u$��V[�00�rY/��oܦ2(���0�Y���?�e$�5��(�ț�:��3��!��e[o�J8ٯ�Iv3����TG��Fd *�&�[,5
��$���������Q�=�����*��m��u�f�kv�!��/����G�u =߀ej�5���uT{�[Ҡt�p��t�rc *o�J^Ukr�}�/H>ُ׫J.��n��~���tS^T�u�\��m!�Q!��H�N�����<��'U}hc]�tt�-v�:�p0n�]b)S�uS����*e��&�D���k�(PDa��`�=\���w�`�Mj��|��^�R�7�R��&/�jB���㧍.��Z���A:�1�Rr�� ��ok1S�3����� XAI���x�藍��6U�M���*)��?���c��~�D����Q֋�E:�MYd\t��k��4������D0��uP���7�2��׸��Z�����4R�ְCÉ�$ն-u #�f�ӿ��{8]\͔�\y7���Y���G�fH�p��z�U�%[kn9��MYϕ2/^���A0I�q�k��B�1�̋!zM�@J7���_ep<�ח�.� /�1nR�
�Ť.�M�-5�w6u�a\�~�N݌�*��m��7֥¯��U��S�4�r�x��A^�kS(�n�<\>7�1nR���n�Sf����4/қ�G0��eȤ�s��t�*�&wVӸ�ժTNWK�0��m�i�����c����IOu�n1��A���cBh�Nw}з�I�0��Y���:�	�nT%�����/*Е8���nV.)�]/�|l�%<���Y̦���Lw[�@R��i #��7���7����/�<Yf$)r�/�L�@ɢ.Gd�ܚ�\�y��"[H�
+O�FQܛu^�_���۹�&�4���Sm����*;W���"I�o�y�Ӳ�{K�|���\k���[�$�C	7@���ց��7S��f���d���{25���M��Bi�s )r�O�"�uO7"�͙�L��*2�	�Ȑ�9e� )r�!/��nr��:�t\�__�F�i2���Z�9G�a\&��e`�}��)��nm�������VxC$E�l��}Ǻܷ;���z�xysL��'_���\�H:r�A�xn�&����l��6[i=(���=�v$)r0�7`�CFI7d� �	؅>�Ue�8 �Zj��'I���&'�,��m!æ`�#�n"�FY���g�NRd�Ƃ�T���ۤ��ͮ/OߛTPVđ;m�*�:�_͢�uƝ�=U.��B��s��rä��Z���;I��,�ܩ�M.�j�1�<�GY4��i*��9��ޮU�z"r���W��Z�x����b���Z�"�ۜW� �J�db���b���4cj�mcܑ����(-�0@���h��d��z�<*�
uzN:�z��Պ���^�:5���~#KW�^_��hI�
[!�uH�h��m7�9�u��r��?��������,f�uf=c7� ��3��W(�� }C���$E.7�4@���>�S�<�����#�� �/���?#I�������s���e
ƌ�z�G�8�UŚ��$��q1��GC�M,imy�*ظ����\!: �#<��\$)�܎O��Z�j3�l��:��_T�5��p�"��F�K�魋�۽a��=����ڸ�=�^�9�"�r]b�2�W�l^Q|:��<b�e���':���J�8˵��n溨n�c����yU���)�D�B����PQT���psY�ބ�f���"X#�p��U �ҥ�7H�Tz�\�/6�h��	�`��\�<�HR��@��b�z�bdƊjbIZ��ۜ9[�QU%��DG�"���*����YD.�.�#6,��-j�,T@N\���$E��0���
J��\� �x�m���$.a�xS�#I���@K�|��������pS�{�m4�Z�H�P�1�6�DO��	�mM����2!v��|���v���S'�7�He4En�� z��a�u�����ER��X������Ա �)�j�ah���m��E�"��h��l%C��獶4
���bo%7XD���6�@:2�ۍn�Z�%ڇ9��>#VJ�%�p�"ӕ_lQ$��m�U,��`T���=���C��߹؀sD5٬q����v���Wv�DFy"�Ŝ��@�yG������jG�"�d1EvG_�v�L��?��`���>�*�]���=���q)],��s���@bI�5b�`�,Y����ۑ��1ξA(�,�CH#��G��@E��+#���TR������r2�s0�T%�eZ�'�L���V"6ōʦNF�B��>C&��N���\�d�LԁC�c	F̔UCo0�&)r������*��kA�^�L�!0    ��b#�K'6�#S�NR��y�I�j�
�Q:�}!����|�!ґ=��\�:�B�o 0���*t�_��HQ�G�`Oy�́td����dbg�mDSs�l3�i��k�&�K7n�S޼ݑtd��Q�l����M�쮼Ӈ
-�>T�ږ;���� �з�8���ˎ8��w�?�+fI�,*�������z��T#�f�����V��fX1zM<r� )�3���Z?ݪ��N�����}9�v�Ì����*�)
,q�!�9e��f|���Y~��#�>4���I�oR/��޶�o�m�u��+�Tcmx��V$E���xY]���Qwd�N�:�^�ʹJM����&��2�$���u����wz���~���m�|Qw��H���l���l,�-�R�N�0��@�E:r�	a�}ʢ�9�6ޕ�~�~l�5z��� �Ǥ�K�eP�p�s�[��YU�f0<���A������?���9�b�S7�ͱ��"��u,�6p"�!��o�v��#�&A�,���AR��j��G3_�̸�9e�"�RXy�,������NQ`�K��OL9���9\�黁�u�
���_�LTIp )r�"ͻ����J0���r
��s�r��1?H
\C܌yW�n���7$%@7��ddUi�Z���v2�|���|�3�m}�#�H�zgځ�
�������?����J*$Ev��֝�Dm1Ikk���VO���n.�J�8+4`� )�v8��TV���ȊNq̧����y�ϣM3�s�"�$y����N��>��i�HĹO��ǰ`�r�������Zb��� )t�lpʋ����R�j�ܪ�0���8|�V��wy#)�10�Z9�.��G�:�����%���WheS�c8�I~��.F���u���Jp��K��3�w�#"��� ��#�X�d���Ⱥ��3�
�F7�n������I*+U�C>H���d�8c�#0�O����i�%z��%��R�?H
�Ll,h��ű��-�V3�Ě+� ���+U"j#W�~���!��;�!������v�Y)��<e�,�8~vQ���>H
�åΦr@�f瓁B s��Ǉ�u����B��e�ヤ�#�<���UP�hIb�T���Cz=��o�� �æY<�sn�#{`>�¶ y`#"_��ܒ���f)z�����)�.$��A�a������;�E�(���\����t���2�6�@Rl�'�fgت�5O��f!��9�`!� ȩ�K�h#��i�/}Ѡ�cJ,K�WQУhr�d��!���TNxK��,}��5ʓ�%HF*e"�tوZ�t ��6�22O�����NQe9Nz#�C��z?��W1�LW�	#��M5�N�*?ޠN�[�郤����	-x�Z��Vc��=W����5�?#��,�?��/�B���i����e�ȩ���M���"�#;Iٞ!�������d%9f�"��.h�:���Q�2ޡ�u?����t�~�H�!��ptsH���ق�i������9A��p�?пHGW�X2�#\�U
�d&vO��.���:�Wq@��t� )�W&�+�4�/����Z<t��q�!#T���d|����������s��?��YA�W�$=��=����"^�B����B���h��g�tn�p���ґcD��v7 �?�+0"�na։���sx2yVߵ�>H�,7d8Y�t	�l{�+$�2���ay�OA�(��N�G�s���!f�*�k�!J�l�؁������+2)�L9���b�K���ͥ��AR�`�2�2a�����0���[��S�Cc��W3��r*?H�<nی�j��'O"2�m�G��l*ϔiV�X�w�w�QR�!�:��J\R�3!�գG��Y�Waߡ#��l�H�llj,dX�l��jٍ�Uf���7��Z��t�˧��!o��<�r[mG�&�����_�%YXv��s$)2�V{8��*����ܚb�-fB��u�l9Z}��\�HRd�|D�U͑��XC�tR���k{y���_��@r�V;�9D��W�*���q��Ҷ�V{��d��-�ӓ��QR��E��v���nӰ]�s������J� )r��>��3V.�q�'{�$��N�FU�)�"������W�ǚ�
���?���oLL�H�.�ˁ��#rm1�"���n'��a&ݦ�V1�H�_���t�g3�cΩq���g��������m��C5<��䝑�����H�1d}$o,�o��26�q�-�U���H�\"�WuGNg���!R印��z��RPQ⃤�t[mĳ�	�bVNd��xd7sbx�a&8�ʐ�ARdWOF2`tA8�)�ş�m�X5c���,f]����_��x\>-��g���}�7{,V�Y���Zv^bi�`�*8��AR���hf���r�t��&�Y����7���,��w )�/�W��I�/��y�~_3ɔY0����T���"�H
�*�%\�(��Л��kA���A��OL9m�H�<n�ͨ�a�J���b��E��4����F��?X���(%�!i��4.6Z�����B3t�E��KS3�")��"���\n�>��Ne2���H��~]S}�4d9��|�����_�"~��x�/�W������vqՄ�~�/�QJ0{y�ur�Z{
S�a��L+���I��a�";������:�.v����z������0���?HG��q!����_*�	+�Z,��Ų�k�3V�+��|'��H
�*[mE���u��K~�V�'AA9�D�d�t˯9#�(!��J�]L6 ���}����ǣ��E:J�*FOW�pH:UɌ
��6lO��_i���b� ��T��o�Q<$�oT�x��~E�2V���yy.|tA>��'4��(�����*<|=����ϸL��6��"���.r �C�#Y�E�ӊJ'���f��@!7$׶?��|P�`�u�Z?HG�|��$˽�&g��OY@󬡄�6�
J�Ш���o�Q�2��n�I N�|,�L�1�p۹xX�N��BV��E����B�)��ȹw8&rM��Ъ�w8�T���LH�T������$����s�UiO�a�V����{��l�ue�2>HG	���Q.ƪ�{QTd1sj�E*�(��ˇ�YG�{m���Ul~��5��5"[�{ ak7	l�R��C�0��Q�*��3�wY�p,En�2�s��@ʆ<�ffX>HG�F"b�1�����ce�G
�l��mſH��h��x8~Z�`���S^�nȾ�4s`��G��R`E5mȁt�?�ۊ�:�
�pd�%j�3mi=�![ro��S� ���k�>ˎ�
H�^�x�ƕ�����/ư:�C�1��N:
_��iX&��0��8��1ݝ�4I,��HB�:�D��������+E������Vqt����yF�t�w�'��oUI�"�\r�������;�D�S�^�>/V$)t�Mڊ�c0�I���UЕf}���#n_]gkҶ����e��v��X�8g{2��6|=uQ�Û[���|Q���u�Z1��|f���=�@g<�׆dg�6�� 4B!>HG�ﳕ��L�����/��w3�ou�Qħlȁt����'RE}4���b�U�{'ɭ�b��z���l�V;��"������3�F��ʲN8`��`
oی!����M��HG��4��Ғ����u�U."���Hd�6� CX�"�T���t��+�^3T�=@�G�:���h�H]zF����Ĝf5F
�U�3v!{f��6����r�J�Q>HG�!�i����֓��%	�4�k1�؇'�;���c���"5�Z@2�Jg��d�ci���M�)����X����(�l���x�n2sJ�Xd����L��y֞W���jo��Hh=�|`<�@V6���fW�����xj~C6C����p�?��<LEg�E�f%<#���;?وn��IF��ţ����P�1�2�*��k��4�:u��u����7��(����GuG��$d�n�<�y��+2<]��9��2���F    `C6��K�b�L@�3չ���o�Ū"�LQ��(5�/�.�}��ŮVy�aA��� ��a�ч�kz��HRh���������>i�'ڋg2�7dx���E'�FRd�;�Ƴm��h$���m��'{�~̙M5W�m�H�\�'ҿ��]F�ֆ<�,��"l��K���C��N:ʬ�ƳWhB��%��iT�|�l�.�
��؈�Q<$�_�T����������Әf��J�J���
��#M��t�J�u�0�ɡ[q�Nsdw �j���{1����e��t�J��Wy�s�j ��}�Aim)Ko��q�j���;�(1(߾�{��1��v�)e�6��E���ѠKŇl�ɟ��xP�X�2{��N����U���<a���2$h6�"��I���������,��!�eι�!7+��E�o����F�7��j:��;n�J���:c���B�7�Q<��o�u�q��c���4�H��ċ��k^�w�}��������?�)K�{�_�0���[�{�+ݝT�(�@��\�v�#>g�mV��=�doOpK,�y�#�(�ǻ�b��:�|� [�4�7��HQ-$����HGi#����ls�r�g�Q���|!<ɋ��?v$����b�rv���u&|�*��v �����'ώ��x�:�B3��u*)�0:�ֺ��N��JI�m��(=��:�ȪM��ȫ5QO_'L�gq�b_ť�������<p��>� ����ʙi�S�t��?g,�ŧ>��]f!�����_'�Y�C��7�(~��Ս������.��\��i�����چ*�O�IG�7�e�|������c������[��N�w�@R��e�d��rj�'�t���ܻ����G�r?�D�O�Qz����D��r=5ח��9��cMT���Q<�~��g�n�i{.�,vmL�%������h"U>HG�)~�1�k˝f���Zc�q��r#���H����9�r�QƳ*e���V��{O�q�� ��dC$�Y��U}N9�}N���l�o	Xe (�0�~�9p0�*�#0���y��63�_x����?���AR�XZ�?˛m�����V� �8���Q�_� }�H
-�I��pVS��6�?����D� �Xe��l�"�h
�*�g.��K�����|����9<
��|���HG�6�Z����NӬ]V����٧e�!����}#)�eʟ_嫝{T��O,;�<�`W�1��IG���|ޫ1%T��q��$����y�o�m�T�S�_��lW����w�T�k	����]  �P��6�I��|�,�%C�%��n7�[n�,��i3���I��%z�Wyq}&��t�Bώgs��hq��]S�9����u�,��W�ʄ8�\��n�+?�Ufk����AR�;��s��>i��Z���صy%&t���$���_����P�Ƽ��V/Ο������{�)
La�Q��6����W�/K��y��j.�3�A:(��PZ�W��_k��L�����^�d��t���)�A�j���z�nOtZΚj)��TI^详R�OF�(��h6��l�^b��/ɀ�<*�r}>�t���%�z�T��%�ҪޞI{�{��9�9�{��a�ҵ�ڍ�x{2�l2���:ԞRќ�S��-�y.i5J���6�Qκ��u�b��T^op �)
��(�3�.�y�d�79�jP����
��f`����(�CA��~��u{���<�0l�#���H�VhV V����rd�
լ��C>�$A��4�I�\ow��l�$-_��u�����6����5>:���꓍D�B�İb��@V���\���k�����B#�:��>-�w�"�XY��`�眫=����6���i�ھH��Z�g���HcK^�F��Y���p#�X{�ۜ/�A��m�(_컑$�+ҋ�ts�՟�
�H�*R7i;�9߮s���Eo��l{�P���=��N�T���I�I�o2��Kǫ�r��|ήʖ�F8�B6u�y�Eq)�5��a��L��xyT1��>�F�IU$}�*e?4~�f#*��x�ܤ�|�"�~1mB�*����u )�עX~P�����x�g�*]k��"�o��`?����gE��O�1a#�a�y9B�|6@�&K��9����7d7=���
�vI%�#7�BGwd���:�M�YV����7�6�b��.T�9�HRdga�[��,�k-s���
��^t��a3><Jx�)�勤�Q��Vty`ΐ<�FW��os��=gφGcl����A:�C��3F�����k����ʨo��-���2[�F��BI�=&쌪@�u�sT�<ﵹ0��F䍅)�"$EbX���g����&�Ơ幀{.��o�8驩tsUm$E�^�����d���cx�����_*��9�9fH��4�!S���I�p�Ÿ���4��ER�X#̿l�d9����K�U�r?c��`L������j9+ŵ��)�Ub5�L�������b��y�L�g�!�烤�!>�r|T���y���Z���F^� �%dh����*��(p1O��7I`�R.vB�>�U�kt嵘��{��#����j\�y��K.'.[�{,<F�L���F�V~�{m��t_i�@�r��1��sQ�2�!�����)��7�"_�a����?�~6EpdO=��V��!�(��r� ��+ݫ��9gJ���f�I�/�*^%X���A�?㈻�𴳭*�� h�ˑg�R��$�S"� )t(5�)*�#:Y�'��&��z��~�/�>�7�I��?H
}EVx��y���E���z����ݪ�/G_��
ŭ�-+ G7�rc �ة�����P�?mt�Y��VSi#)r�'�3���`��Fmz��m����g������v�"I�{�$���ƶG�*i6/���w+	����|x�H�V�筊$E~�d��[�%��������-��m�ǝe��IG�Ari���ά� �zvl�y�^ɺX	������D�ǬZ�s�#� �11��h� >�)��ǳ�8اI&o�-ޱZ�����H�|Ib�|�*�x���
����*��me��T�r��m��֦3���^L�����m��m}��B���6�@R�(�%kTˀN9��`jW���{F��;�_�����.jr���� ���g.��B�Z�JzQ�4�T��K�2%�����H�P���(p�l�a�I����-�/�;�9�]���3���5w��AR��_����v��KD���)l5� �= |a�Qo�����2Ѡ`ܔI,C�<ڧ�[˴��绾 ���|���"�F�F#[m]n��3�ڌ�&�ĩd"EvS�s�rՂ{� ���_j��Yϳݦ2�O�Ϻ��`�!�7�O��"�AR�|�tV�\ܦ6.�Y�������/^~X�w"� )r����#K�q�=�'��Q�K$�yJU}�b��FR�+Iҿ��S�:��\L�h�޵��|��|�����ERd����r	����:�F(��冘�?2�=�X$)t��Y�E���J�a�b�V꫱�۬�M���[��FR�[�0�EgȪc\�$�0쌱�Nw������O����s�(n�o��l[�~�v��t!���X�(�x&�W������-n{#)r�fl4I�ʼ���'{*�Z��dK��P���V�z	x���I�];']�ä[���n
[/C�
���6����C���E:�&�����O�Ⱥ�b�4b%6-:�}��_k�$E��fi�0�&Mp|#�� ��'�uҐ"�@�#}�:��P5�;v��Z�Ⱦ�J�,w�&��NK��?�؍��!>̾i�r<�>����b5b�p�d)�y�"�1��	=tj�f,�H�؀�(�7h���v��:��g-� �#W�PP@L�F\=�a>��H��T>H��$�����t[n �"���R�ؑ�7��*��� )r�`����}��B�d����i"8�c2�"7!�d�/�B�`\��Z�B�y�VY��Q��dg�be� �J��+$�a��Y��G;cMY�M��T	
˹"�w�S����8�mq�    A=T>��*͑;ID.��QA���\/ȖŤG%�9�9W�W�nȣG�i�ްO��;�k5�{%f�D����7�1����FM=��$íɟ���e���$E��Z�#=}�9 ��b�ݲ8���p�c����o�+�9����*f�,^������ƽ��BP��������$���r��,�ݐ����Ǻ���dk��R��M:�9���W�82r�2�UV�i���jL�6)��mUp$En�hgˮ2�j�Y'���ƾ+.���!��Ooȁ�ȱy�X�74�'�)��:���k�~��bFF]��>G�A��{��b�שL��^>��-3�������1�w����to��f�|7Y�����4�)�0[�z������K]�fu�Pc�1)��H��/����cd�N7���7�O�jz�"����\œ����Ώ�6c�8ɜ1%˨��|b��]7%��E;I�C��0���뼐e��<+Y�#*�-J�z7�A����PdUrG��B�i Z�����ß2�[}�tP�ӟ_��W���){��q�1�甛��q�Q�H�
��bÅgS��Yfxm����6�A�UQ'��I��M߿��W��u�f�☫�I�K=d�8s���7Ea�}��g+��K.���E�0���<kj�ُ�������ɑ�ȗ1,Yo���R��d�va}y�����ȇ��D��J3ϫI�t915� ��p������噢IoȦ,*w���9�9_R���I�˼h/!�+h��3��O�j�gn��e�$�.��F�A���h˦6�:���'��������n�ws�rp��Kւ���OK猩��r����^:�G/8E���m���ξPMw�t]��N�K����s�
E�g%��4=�$�b�B�����eV"�2�U�z�Y�|x�~D�Jr�HR�z�#�Yx}q_����&�*����R����M-�-sp#)t���Ӧ2��İ����W�����>|�Q��[�#�"_�0�*�v@.)]s^�<��{�C�Y�0
�n�H�`��^B	]�8@{�I�_n�5��0�������ah�t�:N��fA��,¶䗈%��R�e;b���9.6[�ݪ̣\w%4Y%wފծ�Q���,O�I�\�b3���'R/�ٖ��C�˪�v�Ŭ�z+��kI�P�����ضt��\��M�فc�ߊϴ���s�O��NR�+�{҆!�Q.�=�� "M�2n*J�![���QH�9�Yn^zڊK9�9֣�!q^V}�*C�:[�h.�H
]//����="�9�w�c�Vz9c�bh�<��$(l���b��^���j����>�-S�ǎA���?H�w����z����^���Wd���I�=D��(��I_�������2e�ץ��$\۶ˁt���"���r=�W M�-���z;`�
c�(��9�()��� \zM.��β���x"�5m����AR����Q>c��L��[g��L�~V%���t�R���r�I�W!��6��G�� ҍ�X9O=�/�EG�7T�[�pp��?k!��rprP���fI�>���H`}�(U���V�I�B*f�f�^�dUCQ�:&�7�?R@�jk��T�\~��ƥF�{ �~�\�H�$;��`�fdNA�j���$Engޞ��?S���{]�BVA뭭��{�	�������p�?����r-��P?���Նw��J�I�c�|�,!K�rI4Kj2�4b�O�K^X�^��t0]]����otQ���n>����t����%=6�NR�|-���aݢ�O&j��Cv�P#�"[�l�{.��g��U%׺g�>����<=�G��bWϛo�;m���u�h���Ё�o��s�ۍ�Vo[���l!i��U��[]0���ARd�!7�9e��TQ����0�L�=��QR>��#��$�)�{Y��7K���V�fJg���R,>:�/�ߝ��`������K��y��sҌ�z����B����E��������C/�u���>���
y�����:���\�k(�aF�Dv��{!=���]������* �kԶ�r$)�U��i�ER�6�v�N7���X�b��J�m�G�T.�v��`Nq�Q_��qFʵ؎�&�m&][D���l�9[��;I���0�-6҃�[��#�l��]ⵒ (�Qn�A:�Cɰ��n�9����������R�[x-ek�.|�]<H�R��m7٥Rm�\�n�2;��k��d����]�mC$E�+�ÿ������U���6/�����3��9�Y�j�T����#Qd�^Q��<m��>ct�҇M5��AR�{����2�J=ι癳�R<���Vy�q�����"��ϼ� 0��!�"�����,3��9���?Hs���_eb��qI$���,1,��^5���\%�Ĳ�s )r����ٔt�v;�!�f�!M ܸ��	G�y��|��t�gqWdAn�u�G�j$�볰y~�10|/*��-�f#,����2�����@極�Ka��ѫ�Ե��w#)r����^�s�e�C1w�V�鍬/y�>��)�H��s�"���f^C����\WZ����E�*�}V��.�>H�|�acZ�%7��ً�Q�����=Ų؛2��\�H:����D�W�>����#�|u*��l?K����jwH�"$E�񄡘��Y5�+���^�f��4=�ϼ �z��,$�j�����ً��>�~���:Hη��F2{ ���$E��>{s���e3�c�+sG�u��?x�X�rREϳI�<nsf=�����}��L/7������:0Hc��@:8��-9k-_�M�����<�H���a�P�I��-���b>=��l{\f���7V��v�S��|2"I�K|2�N7,b��ٻXf �b%�m=U�H��|���׊zWsk6"���"�n�W!6��\�v�����q�u7�?�f�y��@7/��M� �����	'�����$����pS�,�D��-d�rK�A:�^>?��,g-G�R��rzm�W2[�$*������R%��ȗ�D��D�~�k�_M��`y*��AR�~C.�&Ŕ�@8[mYE���^b��b��o��f��)�Tn�3���O�L}����;�kH�ی�����3έ=ϗ��n�oV�x	/�n��[��$E����U�^U\��!�0x���G"$��b��-o��j3���ӗev$+uU訯F��E4`-�~�9��=i�Td�f>���֙�����6�"��૚��F�M3BI���3L�f�~EpTՂ�ܝtp�ۜ�{02n�e��;̍���Snw���������(��&����A=t�b� K�KU�^�FN�E9�#�Ϫ7�?0:R\�z�]B؏�9���@���hG�BEҿJYZP��[��6[�ٹݍa���e�ns$E��X���T��Q���W�������|xF��p�X$��gy�L�RR��DQh���l���nu�2�Ky^�@Q��W�^�lQ�Q��%��vd�j���?���O�I���I��,���){LS�}�fk姼��� )2E�����CK�%�#��:Fy�v��wx7y�-k�Ӷ�*����g���^���UK�+��G{Ϟ�����A:��i��z���o�Q��la��kmR��R�?t�~����r�;ў���N�"��3u�*�r�Wd���'���-�NR�v�՝h�M�m\�e�)��vca��u�Lqs���1��?�"j��_ҟ��7ӏ���k˶��q
k+ۜI���E���*⹯ǹ�Y�����|��Jƣ�w���N:x��iT
|�`����Vy��[��VI�|')p�.�U׊�p�����<Oy�E�#+͎ר���}')�s���ٍp(�=�ٟ��"{W"�J���Q��w�<����7���B��9c�+ر���cD"�*�ύ|����Tw��QpH��+�d���l����v�� �"K�G؂��ݨrY��Y��ټ����f�.(�\�����"��U�I9��C�v�n �  �ӓm����������Y=%�,�@����"/[~���+�}_m��r�=��AR�*�,��PՃ{��݊���^�E���z��(�I�G��[)Ȃ�DE�����%#��wd��Ӧ[��x)J�]�H�$wH�e� � :u.:�fS�`�#�Xy��G� Q�K�n�C<6���nu�<r>����/J&���/�{/P�Z���6�"��z�ϲI��{�a�Ҷ������||6�G_���6�B�[���r�dc���%^����,�y�}x��V��cˀ�����Nh� +��&��,�|�zO� SE�`�&H
}�l%�$�����Y���x�ٓ^� ctQ��؍�з�ad�1iʗ�L��d�,����}V$C�
dn�H�|�g`u���qj�쟩B�̜�lJ,�̓�1��̜GY4���"�S�D��)4���Z��"ӫtѭ��C���ӊ��P�|�:(�^ӡ(rFu�������o3x3��وx�k��;;�ܒ���Xo�f�9�����Y2w3{>=����J=�5�D;I�s��-�]φaW};R���^7,Ϝ�C� l��:Œ�;I�K��-�]�ذi�~	�MEͦ�oC7�ѣ����k�Il๓����(��¦¼��84����\�.�K�9�E�w=�A��I��X�B�e�M1M�N�b���|�j^zM; [H��*��NRl�l5m���R���7L�&ڡ�E�-�?�ѱfx���2o�Cr(�c�9;pCJF �c��-��m�y��|x3������~��]N�f������Zv�`�l��� -f�~�9[��a��B����ܦ�ع�za'����z+O��m�}X���ERlϙ�+�Fo��-�jZ��-9��Kw����)W��C;S�K�_������`�����-g.U~')t�M��'x��t6�-H�G>��Q�~�}��������L��촓)�����8؂�Q�Y���J�r�T�\�>>����	I
}+I�g�_���s�d��'�H��i{�`�Cp��0�}�:Ts�Fi�-�UVST	�)г(���Fo�ޟ�(�"RB�(��L��_��3���XMBy��0 �Tƫ�>H�x��j}�3���.NJ%Xf����a�-OP~BG�!%V��$ŹJ�(���Q�h�8��q��5���p�<>H�����������b�Ԭ�m.{�K�ɶ����t���Ӊ����h��C��w��o3��ް�_��;���?O�J�%9����;�pC�F�7�ܨ75kο`[�PeE��W�$�Η�u ����:j9Mf��L��B��C���W
����!��{t`3z�\�홺2�e�{��њ��I�)N�y�0T�׊���=#�},�wӚ�[�Z���胤Юp�����V�J�a�r��٢�*+���b5h���>�E�cyW����g�R�f]��Rۊ��I�/�B7�b=��;�Yg�S�Tt{��,=[��������Hû�r��(��=7;���/l��$���u��paˬ.i%��mn@���s����؞�DEd��ȫg����ED�Zu/"2`�EY�V~S���/.;N`���t&�9�o⋃io)��V�s��W��ݤ�ך�բy��\բs�������ރ�������͸.lk��'������aS^\\�Y
Y
m�''���
#��iK���5�&S�l&t��|v��ԶCOv�B�Ue��K&F=�Q���4�P ^B��䇥���{EuF�ת�:n~�UR����+Zte����>} rl��[.委Y��D�GO;�����
9 �a�����r')v(V]�h!�Ȱ��p��^������ĺ����
�Bp��b�j�bC4���x6��`ϵ��e���/b:t���/�����mg̠�d��,��Xp{�꽱��f��a0�Í��W�1�`B?(�W:�yА����t�-)�2����K~�໓����+SU7�{e���7�Κ���U#�\�i�b�K@��.�U]���_�4iJ�|�^�aߊL��	!e;I�K�ltv ����f�٤�mhfFJ��)�������D$�u���)�r�����"�I�7�a�ɂr�$Ŏ�(�����]�ձO`�X��_�؄XB+X�2v�b�W�]�l[�^���;���_bkN�o��wl,������S.h��ؕ�:�dM�u�G�"���o�;����^�s�#I��dq@�5��J�m�b�$3�˖�i$�Uq�����<呤��2�T�&_�<l�=l�g1�e�loаH!m�T~��P�]�Q�O���d�X1{h]���o��v*0�v�"鐚n�xY}�s��b,�1�U|fԽ�@myծZ�ϓI���ղZMz�,:'��[���)��S�y�,��ʰUP�'v$)v`j�dV�z#c���u�u��o¡�<|�NEh�|��n�f�6h�����^�˞MD��ר�9>����烤�|��+L{Z���^�D9�KS(w'�+t1UM��H
-��xw5_q��������Yk� O����/F��N:d������1����%4̰���G��T�0;�H��ہ��nD���[X3Ev*}zv{?Y�SyX��Qp�?H��
�r��u��R�k��gdL�V��������^P���?�#�z��ֶf.9���w�XyY�e��aP������CZ�Ӭ �/�@��v��n+k˓Zގ��P6TJ��b� 5X	4O���Y�`Y��^��6o����u�j��A:�E?��A�_���C2�|s�2����T��������A�Z�.^\?H�M!�͚$$ǦA�~'�iY��g{�)-=Y�X:�� .��H��*:�86:J.IͰ�V\Nu�l��;[��D���F9�����F�+>���DVb*��瘙���wK�AM����Cf�b�(�`؂���H�ʫ�a���+��+����bŕ��؞��0��ű9�rۼ���tޭ$�V+a�������ߥ�:v=�w;/��^��6"O��R}bG�b峚�ƠU,�5@["�XJX{@V�/�b�
�!v�t�g�@G�}�u��T��c�Gd����Lm��?�(	������������-��v]0e�T�k۷ۖ|�`օ\[�j-�Cz��H6��*�_ӆm�T��ⷛ�r�̱�b|WU*��I
��^��Y�Ġ��$�b�=���6k�z�Pɺ>�#I��R�,�&��U,_dX�L+}�����G*�_)V��I�xF���7���ɸ�_���75}aW9FL	�I�}Eo�vYP��6�-g��@Ubd�z!�,yW���I� ?>g�I�̤�e�f^��g:�ǐa~�4�-uN~a�%<W���'E��%!��ݜ��}U�'/C^��������yΞ�~��6�ݍ�O���lv.g��YW�Ng!�YG�i�n�*,(�K4"n�CFpu�v
#:������9bgf^��o,�����:��S}bG�!���xB3f�6l�댷�uq�׍��Fz�N��������'>7�P�ċi�Xgڗ'�7�Y�oc�(b�^���M2a�Aa�!ͪ�g?c��U�;f�t;��>1��8Oz)�ԓ7�!#� ��Z������q#�G,3>�f����4����H
-�i���,�z:"�h&�}֨R�vd���������-���f�i�U/�b'�� ��B�9�HR���ݞџ҅ݚq�f�U�88�t+&� P�e����!#Jgf�ї�LI+#C5�y��he��m<�w���(�>�o$���f�!�����nS;ܚ��ae�����a�n��Q��M�!0�ZNÊAK�r�1-��ڊ+�,��� )t�t��.�4'U$ ��A�ٌ���s|F�pߠI��팋����⒐l�=5!��-��=��N A�B��v )v�sf��I�؝O��a{���i|������z�z���8���h���?V�8�
�F���F�m{=e��5�&j}o����;���yh��         �   x�E��
�@E��WL����f_��(1���)��
�_o�����Å+ݶ=��@�Q4��E�a�M�'2C=��{�fXN�>=�3�b�DX6'\��H������u`���u�Bb���"�D���bQ"�3��Z-�w�A>�(�]T���I�:I�/[g)U            x������ � �      �      x������ � �      �      x������ � �         �   x�m��� D�3TAA�q��k���X�C�Y�|��'ZB"�&
����!��*�^	��8�c���d��d\UV����'�
�-ƍ���*���<&�i�c}�O���.A���	�o��J7׶1��z'��U�jX���<=�^ƻ�7��+�@�%��9�/|[c�         M   x�3�t�+)JLI�4C###]C 2Q04�21�20�354�%�e�����[�����	�vC+#S+CK=C�=... ��         �   x����	�0E��)�@��dk��?G�@i�8�B��q��q�,��$�@챢ݦi��+�ЅJ
�ܚ\�P����0-��E�x4�Vg�>w��~8XB8[���y6W��#����G?�L�Ş�5��#+���`�m��|�W��Fu�g�GZh��e�
�\���	莂z         o   x�}���0D�a�,P�sl3D&��sT��4m��@��A p�Gd�$ιX]�YZ�a�L��Uej��a�Ѽ�R���ǃfm����Z���>ɑN�q�["�L�yﺛ�>�E4�            x������ � �            x������ � �            x������ � �            x������ � �         D  x�}�I��0 ��+�a �s~�k.�E�N�X.I���g񢰊e�n����ֲ�e�C�����H���ȇ�v;0��DZ����"�U�cڿ���������\y��~��_sE��CI�"���Crt^_��X��kX�[���EH��Cc[H��y����.L
��[H\ԁ��ES_�������^~�kH��
���@b5l���R��^������F$F���k2?���x�s�v�`2Vig�k"�9.I����� �{'�\9� ������y<���p��2��Z��D��ǁ;nG���M���DE���w���m��x����!���%<<�je%��Ũ#����S���M�)#����-$2Y�S�.�S?�ai��4=�1i�Ā�B"�`#�v��D@#m��t�Ɠ�-$B�-��MP�F[HL�Z���i#(�tP��>��UM�}Z���Q��Z�����lD��k���$*��%���9��'S?|�멿�9���~�����t>-�����p(�6aT,�_ɡQ}�ﺛ����� 
-TEF��#KfH�L�H-Te��n��]���            x��}m�����c+NN�����r�ߎ;1Uy��e�]{��c�L�(�?�����#��������E���������A�i���?����c����A�I
I�b>Z��ȝ���ME��X�ɏR�Ԏ#����Z��6b	�<�P�i<r�,wR��R)�2�a	�>� n-זr��0�te�㯱��� {;4���I��Q9(G.y,�6P"����_J��k>$'��� �o�ԏ��΅��"�߰��u8�[�?�G���A��{�ִ��[�0�'7�{<Rŗ-7R����k��)>M
US9�J��E�Ǜ���~��El��o�S<*F�s�w������)�l �J��f2q-w��N��O��6?J���Ck�z�(��٠��X�%h�J�-�{�\�ʵ~���/���;�@�VZ~I��m�hYc�_��m��o������m�ov�����H���#c���Av��f[�C�+v�v'%[����Ny�`�6�7�$]˔n$�S������;�@����N���$��U�o(�4�L{��a	�<�T���R�2bx�7��Js�;�� ��m�LW��gZ�͎�E�n�)a#88��H,bϴ��^M9��v�,���nـ~К�FH$���$6�[�Do��`����M9b��Kw(:0�`ӎ�X�~К'{;i�|'���+7���`?h����q��*�]9�F�k��Z��S:bN���l�<C��hY�~К'{�n띔���a��X�~Л';����m��jkI�h��B�<h��%��=�FJb�Kj0��2,A�<h�΍�V��_n���Di<�� Z��)،�9�Έ����td�5O�lvAa�O���N��RuB�`C�}���":���/C}�^.����Ŀ���XM?w��dvܑ��a�h����p!��Ro$(�O>n�+��!��� ;�#�p�;Ia���}l�C ��b,p ���0�U₭y,�6��@Z��&3+�����|��[�P�ElH��ή7��H���hv.cCz�uv��H�D=�&i4�ؐ�i��m_�+[�n5,y4/��A�7��a��~�r'���I��h�,c�>��ή�O�Q�M��*���KР���do6�X��o$3^�Ts�!�6����I���#� Y���TȻ!;ؠG`O�5���_�l(=j�\�[����9;{���R����b��A�"�ؠ������K�������x�.b�>jN)�H�������Ê'�'>��ؠ����{N�ƫ��`鎸�Ʊ�ؠ3�y�Ws*���E1K�<.���'Аgz��۳6����Iݫj���;ؐgz��N0�2v��I��c�����y�9���H�q��E�"9͹�y�9O�|�k���Ɨ#s+�mdАgz�bWl�Բz��������Y'v�Ş�ݕ"�'�ć�8\ �ؐ�p\`5R����4ę��Y��r���	@g7��(m2 A!�-���ؐ��X���NSt+���V��:]Æ<��{9�Ъ��9�!6*���R�aC~�ޝ���W�������`Cy��|�h$�x��f��UK�5��P&g�쭯y�>l;s�H�c,ְ���s|�}�[4(Zh�F�!�9����`C���]��`s��h�2��E�¢���޹o[�I����"v���Ǳ0��/%�ks�1�� 쨋�Pʓ�n�L\��Ğ��yJ��"6���F���2ǻ�~�\u</��<j-coG������x�(�O7��ƅ��$�RS|Yص�����6TZ�l^&���G�ߥR�*k�,����C�\�{�t�Z�Q�l����)�<���ލD=
�}�l��(��.G���� i�??�6�G���ӑ�1H_=Sq�l��6���#Z�x�#vF��]~I��u櫟��vdK�'��!���5l��zSm���׵��dip�|�5l��I[�e�i�o��l��nL��u�"6��y�78��"7�ɇW�����As��'���G��`�B2�b�g�����)��`*��Ib�<�W�;���S�r(st�jg@�<$Cuڃ�k.��*��ܦy'A	3ܻ���
���}s�s��A������v���B�{�}������G:�Rne������.sk��'۫F�Cgڃ���z�h���=���zp�����26�:��=a����冷�Y`B�&�26���v߾a��|�v�mG[���,b�8_�';RʰR=I��-�<�,�x�V;T�<\�Xݯds'�P�?�X�B��x�ɟ�����H��g�9kX�!O�����������	�GFzk� �|$���r�\n$I�57��;X��`���^�m�u;֘�d� �\�Ԓ��d���Leq]�;�{�\��#�j�#�Jxh�B!�C��d����|��`�ء�)�� cn1�������--�TO�&�	/����zUG�?��/��	J�ܣ��ȹ��v��h�<��%���|�Jy��+l��t�b̢�ߎՎ{����$�~xݨ�~1d�QN~��x7�c_��+�l ��������dIG���#!��Gܭ�r�w��z�`�g�16��^�c��oqS�4�H��@T���3���'K���7�����u�#���<��"q���	�>��A6�b<h���H��te��v�?T��P��
�����j��N"�~ ;r
���ZQ����HZ�$�4+�>g
!f����0�raݓ�%v0���!�b̼�7��g�)vW9�_J�K1^!�X�13�:J= �j�<Wx��K��3�w��xvLt��6�|�Wz���A6�B�ζOvۛ�h��}���3���kX��R���mF ���2H9��B�G�������H�,���:Y��(���D�\�ܗ�Z1�<8���Y���/��J�tXͶc̪㏲�����k�KYY܏��/�����B�5���~��Wh(�s��q1呥���ss��W��r��G��A�B������w��L��>����3���g�7�$�'���h��$sڟc�^��ݣ�"�Z�?���B��=�a$�W߱}#I�������X�B�6]�/~��_�_���4���t��"6P���/�v��Q�?Z�~^I�
�s���|���w�H��l᫡�X�B�Y���.{Ϸ��M��:
�c���l����4�"�լ��h�ul�49v~'cq��u(�&�ܳ��2b�l�0��K��U��%�Gc1�����HRKQO�mg�	��|1�\g���ԏ�����F�J?�X�B�YбX�Jz�{���,F?IɎ�Z�ѷ���B��z�+�5OJ��&7�$�`M�z�ŨL��F����J\���b�ΎN������U�x>)����-�(��o~����6}�zAzƶ�݂l�i���(�l�m��(��v�P]�shZ^t���e�.��^F����h �٠�'v���a�A�d���X�B�YqQg��e�c����|-�������`�����(��P��<�����,Ę�6����T,�t'5[�:J�؀B�Yk����@����I
��Y�;�@y�:������߿҃�񨬾��b̒�ޏ����)���;-�F��@y�<�k�r�C�v'5UL��_�B���y���X䳃EyE��TF��6�e,�H���>k�I���FVW��(��=;�@����>�jbw�zݭĬ��~1f��ů����N*����`!���|�i�Q��J5�_˗�l@!�,��bW3���A\�#A�W�b
!f�����L�8R=;^J��X��ʃ����/�ݶ�~0��[�q<=��ʃ?��a�܂���ST}b�b<jP��)�RORO��_k<?��ʣ�	-�͐�g3��{��P�5,ĘE@/�|��9��۬��Z�~�2b<؟'�X������mK��St��b�;Z����,:r4|^_j��T5�E�,�Ir�O���㠀�v��Q��b��"�_�C�xX��Jt1fY� s  ��VwJ�VK���7����|�[�O���̬W��{;�`!�<�`�~���Z�v�+��:2Ǘ�b��~��g�6H��O��B�y�:��jKmU�-��d�&go3/�26д䨾`��n�Ije�I[�^�b�4��������̆��{&��@u�_��("��]�K?c�ʕE����B���Q}��߶���B޽_*�Tl@!��i����N�$��$�b��s��c��%|5[֕$~?ʜ��!;QvU�[�@�r��ز���� ��3�H[qm<��crzd�d��=-��ۣ��9�z�	�9��B���|���*}���$��w��N�����Dw^���
��;�-�;�V���na!�$����k�����;�du��6P�����PR�_�Y��v=ж���D�^�P����ˋ���*�?���B�����µ����(aN�0�6Ь��_̽��H����E#�����0�?��]���l��:6p��0]���X����l~��=e1&>���g �̅�'�h���_[X�1�����2�=���\}��h�8��_�=�^W���1֌~����ge?�%�կ.�U�[��d1�uh�stͷo���
�>kH�s,��a���ۡW�l��"��zJ䜣(���]�V�*�|��_$�X%e�7�<+��ح��E���Z#��R ���Aw����$7v��݋��S�-l`z�@��,Ө�W�z�j%�?�X���y:��Z$�X=��HU�넰����䷨}$��(���ة܏	�<+���OG�Q��,x�;$��B��y�c�S�a�u�=8bC>������Aw�7~mQ�$��C�	�󗶰�Y�����F~�	e�5Aװ�����0�EY��FVAd�qk.Oz1u(�ں��b�$�ƆI�����g�??�R����n-!-�3Vw��<���;c�\�=�' �X!׵{��'u}E��*в�zϜ�.�؁����gK�{�d��ICCg1��������	�}�J�~L�5,�x��O~k,�͑����rs}���QJ�RD��FҋjhTY����{�Bd����L��S����m1��t��u鹓jo~�����B<jOc����p3X������Ȯi1��to�r�`��G��ox���na�$���awd�o-x^i�G�"��κ�,1�d��M�P��NI#������(���]��[ah�������$ew��6����c3�+%��l�/kI�E�6�<h��jw��h`K���춰c�A��e"з5H��f�\��-,�x�@O�v�*w����(��Z����W�����E�ތ��P�/c��}��^�c��i��ߑc�f����3���
���e#�I��Ѣ/���N3���uG?�V.�Z���[(P1�A/v�}��������ʦ��l@!Ĥ��b���+�{�f�a+��X���jt��r�}a�H�w��q�,Ę��_���W��^�'k����ma�������[ju�"�-�x����3�y���F`�}^�t���Z`�H����L���
�;�Y4����bL�����R��#ߤ^�I��&;��i����o	��ȋ��f�K^������B���|���H��*і}Lx14��o���t'��EQ}��(��y��u��϶'�zpY�;�<�-l`�EA��ʇ��:�;;�J�c����x7J|_�vG<���բ[���������rm:x��;cKp�X[����.W����2�`����l�Y������q��I����<���X�B��z��a�V���ݒ(�^�h`}�?Ov9�iW�1q�c֢Օ\oaϊ^���j��˞�����q�u$Dxԝܻ�֖>�_��[�V�Zm,�b�<��{c���k��-��\������'��ȁ��Y��"u�OKL?��"6�욣?~�&� �+%�.6�ƮPoxV���߬6%��L�n���kǺ������j�D�1k���5����<�c��zg�:Ro���cg8�r�.~+����K��o�7J?��El���A��`)����#}���Ǧ��\fQЋ_-(�S��z�2^5��-,ĘEA/~؊x!�~T3�3P᡻��-l��e\����?�e��H�D<�X�1��^���ɝ$羕��P��<���_���<)�8<�� w��˃m��s5;[�&Y�f��,_����~|�[�
�9�r'���v������B�+��ƪ��Nʽ;G�yv;X����w~�%�o�}��E:Z�:',c!�L��6�g��D��ٓ�L!�����3-z�)��~�&a�����!�
6��⇺���!��q<����(��EB/��spF��r(a��exv���o�l�w��
�I��`�;���J�?~�+��!t������X�B��ͯ���E�l3�"�K$��,cי%z�n�z�V��²re�;P1�C�^�=����$��=<�����3;����+[1�m��W�����w14��_��Y�������2U�26p{Р�ߒ}s��3�"�v��>�ixZ�t���'�_���J������3;�⇽P��s=�~L�Z���P1�B/~�L���������)r-���cf�^�0Z�z�����K�tߡ����z��aW���=�{�{w��b�b�o~���.i�7�U�~�S$v�cf�^��,�}�>��f/�I�����n3+�ͯ��9���:f[��̑�Z�B��i�ŏ�K�r�㐥Z�따�2�G����Q��F�ʊ��G�GcdZ�t�#���W���]|��b�Γ.�l�*��zj?!<
����Z��V$]�V!��i�/�&�����5h�i=қ��j���,6�H��2�G:���c����;I�7�$��`!��
}�g��z����`�XG(;X�1�C_�6�X�N��ȵ�AU�B�N�.�|T;-t��B�����;X�1�B_�ֈ
�k/{�Jѧ�`��\����p���ɓ��+�oڰ�2�Jz�[s����(����5-���-l��)������6(�T{��{?Cw�Ah��w~���(���-�d[+���]C��B3;���l����윤�����b�<���1�@M[���u��I�,�nYM���������`�      
   �   x�}�_
�0Ɵ�S� :f�ݛ x _}�]�ږ:�����ё��/��Kj&ٖE�l�s5vt��UKYG`�"�����˕X�
r�J�M֔U��I�dۤ%1zk��F�;s4��n:Ҕ�B��'����? �Vm.2�U�3����&���6���fHHl֐K�ӉR�E���-�}�9�a�         x  x�}��N�0���S� J:S����D�g/#T�ZCa}+�#�bκ]�lCm����L�E-���|O��A���sQ��<F��T������v�vJ�����$v�}��k��Oq��_����m�*�x�HÊ�د�ˮ���f����8�e�Yi�%���d�����WwOI\���UO��b~��S:)ְ-�F������v�JP��6�d+��ߺ��>+�,�訤R۫����[r�$(��<hv�:bظ�y��:�J�`��� �p<:�\�4����a���e��oxw7�:.�.����t��� U�$�y6N��_���3��'?d�M��U��A4�_�D�k�^L��J!+Ѫ4�`2HޕR�*q�         �   x�3��L�-��tN,()-JTHIUH�ə�7�89��
%�E��Ŝ�`hd`d�kh�kd�``aebjel�gabf`h�G�˄�3/1�$�,3%1ٲ���
���E%@dy^	�^��T�������������� ��>S         4   x�3�4�4�4�4B###]C#]#3K++C=sKCs<R\1z\\\ �TZ      8      x��Ms�H�.��~EF�������7X��AH��2I�l�;	I�I@���;7b�rw11�w�zw��EG/nDo���/y���G(��U���n�M2�@x���}��=��^����*���9#�y��ӈL��4 s}���	���������*MMiRY2TCS��ȏ�G&�CᓲmZ������L��VSћT�lKV�;.ssZ�,Ӹ�2�b����xʺ%kVSU%͔S),Yٺ�´�!X�ů:��d<tz��G����;O�;�9I�-ˏ�A-�����e�2�������nk� �(<�ŋ�|��2 q��g�#̉�z���`y��Y�w�\��j�3!��O~���ɜ�_��iz?�g����l��99����׳��$Z�%��)��|���p�.	g��iJ��ȟ����Q����,"�xv��H��v�$Ί�����O~���O���^F�8��V�$Z�3<��j� �M2_�<2@:��,8��:�_�FS6a%~�7I�z�Q ϊ<�L�^�ҡo�����_�����E�t?��SL."��f��ǋd�U����:��c���\�λIt�2|����&�_�Tn�T��4�"���ɿ��� �vZ7
����'�,����N}�++���F��<�'3��2b`��gQ���n���0��E��"B�Lu`<�"˪�  d4��!L��& ����8��K� ��|O2�#�8��J��<�s���N� 8�yD.aD&k\\ne�#�.`36@&~8���Ͼ�V����s ���ߕl�A���A��+xx�V��为�8�˨A��ս��du���lPT�÷��,$'�|������l>��x!�*���~�0Z��1���An�����I��e�+�h���ʲL>��[I�� &�e���͏�� �k}s:C8K�+<��'�isVZ�����۪������x���G��p88p�Ͷ��{������d�k��<1%S�U�8��;�ƃ~~��0����{A��)�8c&9?�f쒱��v�蚽h�X�^5������q�W4�� !�#)]\�������a��+�e�v�fE�����bv1fϞO�)�а3+[!cOh�A�d5dS�d������%{l:�͟�8:��Á/C~2d�H'k�$���֓=/�/A��0���n&� v~��`����=HI@j�8y��g�W�G�����"X2�%��,9�������Rk �]&�O��d�ޔ6e��X*���� �4���� �GF�n�팏ۈu�����#G�� ��o��C�w�A��[��*������N:}2v�~{@\g�^$x���y�A���<V@���8d_p�L���
�2B���PvZ��(� B_�)�)N��_�R�e��6�f��L������m����Ѳ�ڗ�PQ>����m	��JʀUWR)�����a�:���t�@^�I���7�<x��}�K��B��$��m_���2�Y���s�%���b�*��#��t�S����
&~��k8����� d���=Aֵ$�'�����]��H���Q��x�'�����(@�C�t���M�
����w�?��鎝]w0<�C�����j&� 
9��7�F%�8���,�a�;�	��{�"(�((Z���1�)�`��޸?��|I�Ѱ��`c_E�>aʴ�.�r���M~	"�.@R"�#KÅ���)���"A�v�ȗ �2mW�^�}~h?Z �~�N����#����`~��Y�/ǧ i��o��Y@:���'�.#`��᷈?qf����L�gK��k �)�j�y���|�^��nX��"Mֱ����3|Ul�Z������rƯz���B6[3m{W�d�=�0x�C|.T��|���˰�DI�n��R������I�������t=}�0��/��*EGTqDfs0Gֵ;WD��H��rKRl�R��(l�����������@=��Q��U����kI#�=C�v���S�V?ԣ=P���
��r�Ѵ�lI2���z���0�~�G�+����|>S���蒩�R���R�8�~��(P����5���&�xv��k�a�VJ�ʨd�����s�L�6�~Vh+T=�H p�?A?�@H������c*�Di�zS3@�������NJ��v�"w���w��"	����D�V?wB�;��*�Y�ʩ���BeU-�Z�.���!X��ӝ�xR��Z�]��/�4�v�(ʃ���Z�D8;얚l�XزVqZ��V����
�P�@f���iJ���ND^h~JT+ZS���P���Q]�V?+7��[?1*P�&٪��M}�~��i�C�Z�m�Y�[��s󆹹�،�9�U�5ۺ���4�~@ilF�㱓��c�Օ��W:����(H��0	��|^�z%��?`���>q��<:��O�?v\���z����������M���@�C�{C��#��;I�㌝n����!�����(�s�`Nde&7?���#@W\��H&�/S21e��y���I����gy|��O�,��jFW@�C��2b���2�����f��,נ��K/����q T[���9�R7e�:ViZ��U�_@�?����)@�U�p�O�+Pey,�V�t�I�����mيn��w2�~���;�ĕq���.7U]�͠�W
�ꇀ �x �ϙ 4�i6�7\[	@�V?�>�|�`K�f�=6�0�n ��=@���7�uY�mM+G6݂�lV��_@��?s���VS��^�V? �D�O��u@�LS��.��.�´�!X��@���ْ�
XE��b���:KqV��?q�9k����<$)x7	��5X"��l$R!�P쓕O�`�F����1����@3]����Ĉ�9 >3�.���0���,n�schbI���"F
���`z#��]���ӾbYO<�	�p.��J�Æ{,��|�?�\/�1Y�)���ͤ,^��;�����uO:��,)F\fC�e>Y1�m�&��e'������yᴼ�r���1�C�����]\��L(j���<�|��N��8#X��<�Ħ��t��p&ݴMf�~�t;�����p��U�	���a�4uv��3t����3�������:봩��n�|����:* �`�{x��S��G6w{~��ze4�\.nߚ*g�����s����&�ዅ?<�]k�2���,�j(RH{-�|"fy, �B.�ĞׅOd[�P|�{�`�OSY�d*�L���vpȕӲL�	�1�jƝß�|��Dg�2̳�+~˓����,cnζ��!�&�&��B���y�,�,����mI3���o�+>i��2��
�v��n�z��L$~��q���p�i�&��q�V�8�v�I_�/����˳�׷�q-����9�3|:ɾ'��ח���& �ˍ��&X��UÀ4xI���ݓ�K��v�&�(w��ΰ縝������Z��`�GN���Y�bX
�%*9���O��a�IXc��;f<��?��푖!Q��ʷ)A�by�<��/>�$��� 6���T� X\q��������$�]8;��w׳e"\L���� �X��Q]c�.F����?���h*�G�W����� ]%�Y��RI�Z&lXr������I�lh��rR����Ÿg"�b�1��]X����������>��9G�-f,�Ab��:�n�XI�l/��s촽>@����-��݂1_/�j/C����,W"��:�S�E5-��	�i�C |Z�jԃb�X��ʤ�?v���s�����r��{m�:@{y��~i������L���w��1��n麺7~;ޓi�C�w�ތ��Բ5ޘb�I�i��d����� s�]�>�yY���W��������x�����^�V?xW����%]o�A�s���!��P��dM2�,�f�����j�kE���q=��uM��ǻ��J�� ��=    ��s��^7�u��>�5�o�jj*b(W�~@��b�mE߷\�׎rL2QL� OgՎ ��{@��Nw�bIǅ�s� .ۆ��L~G|k����O�o�QT���Ƿj9n�7�U;�6��=�SFe�Ԧa�	f���8=�9q��3�Y0~tF����j��2U�r��}�׏t�T�{D畦���:f^���e���F������%���$�4���<`���Mݠ���-X7%K���˷c=�V?X�j� u�b���@~6�#�;�΀[�-�؟
ئ�����%������+ٴ�! �]�
�ꥪiT�:���t��`H��Q����z#��9��\6���<�fR}����p�ݰ'��.$<)e��>Y`œ�2�h5;Â�7?lzR턡�N����3a�^�1cײTü���0�~h8�=T�/QH����,��+�sp<w�I���A�����7|L�K�������TZ�k�����J���:����
�� ��n�z6�(�\^Ve����N :�0�=~��Y(��xUU�F��{ۖ������&������O��׺I�/[TI_�贴>;���}��&�F��`c 9��2��}�]�Q N�J����}L1�i�C �Z/iQ?ચn�L0ﴟot��X����vYl@�ʼ���`_�tPߗ-��U 0UɴMS�O@@aZ�@��KZku�U��5�s�z�I��#pF�������h<���s{�!��Q@�m�5�WmwG�j���l��i�C;X#�]��U�7�1�/��u[6uj ƫ�Rt�}x�y�~% �Qj��x ;�zj���{���9�ZAb�1�7��g��xj�r������޻KF
.���Oy������,yY ,�:Y��9~�"�~�%�^6~���0r`$�xc���x��L�XY]��E�'y�D!�+Nj�zm�͖o��S]���0���y�v�F�z���q{0�C�mgD�> ���軃�D�X��Ov^��ka���)��Q|�l�^���;N�=�F�P�g��$�?|�GhC}Qe����U�%���l%��LӖ�V�Lgkl�Z����� �[���i�C@�^�:����ܨ�""�"_�~ o��8	E�@�vFnfбL[{��|:{�Ҷ��_uԔd�t�	�lZ�@>��l�ic��<�����u:�l� .BE�6�#g���äAw� �-Th�?~0^����`��E�����c��%=�6���s��=`��65n��|BҴr�g��e/����vV̰r�+���k?�w-����y�iy��C��W�3d�s�\,]��#����br�������W�W�DcV;n��+'��G�Wٷ�t/��:�����C��ί����v�F1M�0���+ݮ?s�o7H�½Sy��~��,7��9�m/�;���w]�r@�?rZ����$�%OW���l�`�?ܾOhdaZ��=qŶ3�	�n�����kiX��x<��2y�1ol�9��`42�� $΁��L�ϻ��A
D�y���X^�A���Isa,llI�;���'%�{�-&��� ���Ë��O;j�[���E�&5���h���]�=$��R�K`������(ە��E'� Y"�����9S.�֐}҆�)���L��p[U+�u<����s�0Y^�`&G����چŔ��p!��հ+�j6t�J*��u�a(k'�6Lݐ�����j�������f���h����jK�l)�}2�
��v�!8hs�{��?��$�R��I��Ϳ���6Z6-o0�4*|?]�@��g[B^�q��;g��'jl��2,fݴ���T�ʟ�:�۳�&��1p̘,~̓U�1տ���Ǣ���ŔtK���65���� ��&ґ�S�>�´���I�#o������j+�ݿ�����͕��Z[AW�Ԗ[��W�jH�V�*������Us{-���jQj%48��[pSg3܈�  rŀ�z��xS�5v���w|GC!��D}.�pP���X�9�ȓ^��&�D�bz�diN���\_��R$�e8���J����#�k�b�KCҞ�K ��D !��Q?d��Y��,i<%e�i�+`B���a�f�n����4�X|b4��k�䅤�1R�+~?�������kv��Np�9�������4���������}�V��/V����^�����F��w���UF�0�~ �T�V7�,Ԫ�H�aj4+U���#2`�Dǅ0x>\�cg~8�v�� צ�">�{���:8�2�!.���{=Ё����I� �_Tl���qM�.�/N�B�)Q�K���k<�i~.X.kڕ��`L���v4Ys"��%S�����f�x���$䵃j���z��K��Mn~����`��'��@�Θ��.n�X�O��vڎP��Yw-v&��췠GMbQd
�Я3Q�I��p�0l[����n�я�MӇ��Ǳ>v��މ7"��66x�Ͽ9|{����.i*������ �����������m��q+���S��	�4���c�����xDt��A�@�L)U�`8[|N��u�!i�@)Q����m�Tl���L�X2�V�#�iT���Vn�"i�ϸ��+l)_�'���+q�?b����V����ii�M�X��l�DI��L�i�%��e�Tj��:�b�N��ԩ4���������R��k2�߭@�t�����g�/�z������*7-�!�*z���5�@�0z�ǯ�'�n-���B1�A��j
�� �����7���Adhɿ��i�C m�BdAs���!c������.1&��Ln$gQ"�8�[񰭲�I�*�y�	�8x7�CBr����r̃3f��u�ж�	U�R>~Ȥ�i���@�3&��@2A��ru�g�;�!�E�K����X��!�.d���j����� �0-A��`Rb������ g�A W�{���i�ޚ�*+���G+h~�k3���W�?$2� �0=7��H��Ϳ7�h�vxl�ӿ��~��;˛?�$��D���E�q*n2ɉJ�d7��������X�4�J���l��dYT��q���ž�T�t��Q&B�H�dC)���Хi�C�t�dH�s#Y�)S�#ar�y��Ҵ�!���{�ҟ�+k��G�4��]�4�~h����>��gH��W�X�j݋L�i�C�{�������I��GJ�� �U���?��o�{����i�h����i�C;*�0< ����:��]��/�MM#�=]��,-��O���J.�qg�ڔY,���y�_�Ўj�����{��>c��(�?�M���l�&X�ߒ���4�?~�O��V�Ws�Q��i��p�7�����?�8�E�M�-��?E䑂
�Us���%� ކ��WY�͒mm�Ўf��=�;#��b>:��i<�oh��m��߶&4055Y�A���-C�4UQ�W�����0�:%�B.��A˽��2OqZ��_�>���Yi,��9���j�ѫ�%��6�ť�-1��|����D>ot����a܏�Dz%iab�%�s��]<v�9s�������%����'��� T2@M�/B܇7����Z�� �;�Hę�E�2"��

ȗnn��J�\���U�$a�gd.d�M�89s���摺H�!�K[���.o��Qh ��"�	s��mL��Ͼ��B��Z� ��-׉�f�$ұ�J�u���RȜ�42��[r��Hf��\�W��F��ʜ��l�g%nj�l�E�PdM��gqZ��Y��7�-��1,�������%_ga֗�������Q�� ����_��9�T������E_�!ي��{��@iZʭ^�{e�`o&r)���:��\��\6�l���(ư���~j�S�)�N�J���{`��$��	~�p�����,$�t�)bW�8�������^q��+��]�P^�h����j���i�C ނO��93)��+1eK��Mv+ҭ�n��DL�]%��_�y�\�T̉���A��^@�/�b�6b�8f!    ��K�z�~Y��S�bO4I��?#?sF0���<;K���Ԯ	 s=G�|,}4��]�3v��R�|�k�3�M��`I�O}0��Yy�	J�q�Xܚ��G[�P��"��ǳ�g?���*Ʈas+�PCgW}-��@���o���e��tq�mP�u���ڶd]�Ϻ�L���m����M����@�L����Z�U;��DT����2پ�&}�y�ߍ<�%���G���2N₏0��
����4x���x��;X�V���n���I ,c<�cv�%����kKr ��#x��~�x���($�e.ӽ{됝{>Y�x��\�sN�� �/�*?�dW&7�]�-��w�dy����5&(3�i��lђ�v��e2����A���ur6��c�W�4Jb���=��o�o5���g��I:�<xns��34ak�G�t��l(�ޥY�\)ŝ���I�Hi3�D����5l�S���Gj%�5[R�*_C�+�O�ۛ��oK���o��?!���$A��^��VG�� >K`�� y��l�M�����D�2n����~�R^�"��@s;�G�I^ȍ���̱b��s?I���p�eO�1���s�Q8���^�� u������gq���a�璥H���<D$�?d[��Kr<��i$d��0��QU@�����h!����`��_OP�;��a~�0����c�^��7L�Aȯ���$"Z%���Y�DΝ6��E�ߝ��q/��0qwNF>��t`׀M�w���v|Ö&��|V��e�����u�������E�9*!��͏xk���t���T�Nx�3���z6E�m�K���$`O�I����<��H?���p-�2ZKkR���㺗��Oְ��UQ̔�ap?�X��U�Si�������KI�n�%��͏���v?F:i�bm���	�`�@q*��Wܙ��<��ﾸ�M��?E�a�����  1޴��,��T*[!�O��"��!��0��,y���p��`�����B�sg��t�Of�˗"�-%��1,���	���s�QQ�ѓ!�7���BFU�Q�
ѪGJF��:x�N���0�#�\��s�Z�w1 V�&+�����D{ a����nG6׆v�6�{H�P �@�6��:A[���*�I�MF^/i��("X��3�P�fT�t��T���N�n�'�WAκ���t� ����bPpr�8�#�(�YE�-62[Ϧ]2��	���kL��Q#-��H�m��_����>�3M���'�L����X)󁀿��(����T�?��%���Z�AЍ�I^�ȇ2=�@��K6�=eנ&�ބI��n(y������4����+.���1�ޟ��\�ݪ���F�K�$ɐ\͒���>��}S�W�����ePl	[۸�L��l��%wPk�VT�/S���ífՎ ���������T��G�0�~hG5R/i���|tt��Έ����<����c��*�V��-C;*�
k�?�WZ�żҪ�閺eht��=*��~ϻ��<�Ȇao�{4K��j/���'Cڠ[�v4��U��{�G�Čj�R~��l��V���P����]BMx�wI��B�[Ѕz��鶝��Y�ݰb#d�g�K��qr54�N�T�S��S�T�:5�e�_V�:���G]������dC<ں�۷�_z+�,��(��o�~���R��Xz�+��y�����!����U(����%��Wb����؞�5oſy���? MnDK%���熫<�1U��lM�����~��x1K��9U 1��[��7ƏL��7�q��I�`�}���v@ꭾ�r~e>��պ���nA�vR��?ED�-i����
u W�+��i�zm�0�~ n� W����d�J����1$�cE"��i{���(�bY�3�G籿��8X����:zf��uCX,�qM3�͟����mN�!z�Ђ={���,�U��w�|�X��u<��^9��v��s���躝T�����k��q�J�&忂gI�Y�Z>fK��ɲ�T�1n��g�Aю<_��`VڑM������"��k�<�Չ�7��ʙ����ߑ��4��H+t����_��I��֤:v���}ܻ�i�C b1lAQ�{A��_��\����J_-u���E~��. �$���"�#�=�	+J������K���;'��79v�NR��'�p\�#Hc��?�;C��_-OXp�Ǫs�h��:�1/;����R#,s׃ycV��}��I�0�� >�����Y�� :Z�C�?��,R��a^��ӛ?�����\I��d`��ip��W��̷Ai��_���5g.�ڌ{��[�U�Rb�	V»&�IF�2�
��Oٯ�eR�H00�AUaM��H(M�4[E4;����Np���tOV��/�S�D6��@>x� M���),P3وV �YEǟ`AZ�ym�#t;3tg�_�K���������Ӵ����
���QP����(�5�t�ޡ�o��X�;�8���#4cN����1����Z��z���}����0��_9�ћ�ܿ��,NV��@Frb��$�QG���"�,��R�KJ���"��4 垵�K��$�e�8����@�"�:ըdʆu/����"��X�u��
�~v�P�G���$���(��Q"=L��p7T�6
�$��E<p�!����j����&�Tn~X&�R������EQ�|s��f�ґ�t�� ��bH��H]imf��r���ξ� G,�6	RX�\]e{r�Fi�͓R��i�B�[�iA��� �΅2~n?��5��fnȅ���<���KLN�1!��A���}1]i~�&5M��8�
愇���{�\��.hh�)ے�c=�;c�4�~h����E"�>�U"�M��H-���E�{������a�?I����� (K��E�3�K�� ��?��Oˎ�%�����!�KtX��!��RĮ�������Ԁ��x�a���Z�N���|�l�b��L�"orv�o��^��d-!�i����k3��~��CgaΤ�����ɉ��3Y1����|ؓ��\�1�<7�_�yP.g� �mĭF��m���,X�q$�<*.���S������,�r�p�2��U����a�qQX���`���݋�q����������+�k���b6��O�	���!e���bV3~,��_��Tv�U���a^K�l�H�+��Td��d֛��i�C x1�@���j�bd�蟸InO-b�ܮ�p�L�^�;��h|̛����:#���s�(
<�<�@��d������$@��^{no���r�7`C��w���� ��� ���*����:��T�}{W���]+0�]�
�np�Y�Y�k��o��;S����L%��F���b���oNA3Es��J�+ �q�y�ӳ��uD�ߴ�*�cF]7�&a-p����mb_/��Ww:�ޤ�K�.���Q,�L�yn�J)/�S���QN��.��t 'eW嫭�G~<��T���
��=�ZP�Kba'���_�U;�/8�G�x�is���09<���H��/)
�Ư����g��*<���J��Y��HՋ���N-�T�.>1g�i�<o�D!Đ7�s]�<>X�������eb ���ۼ���6���������(��y�~�9m��8����S"F+��0�-�7�A�R�u�[�_����NL]���а_������%17��[hB8�1gk�D3[��,mE�����!��O,��;��^�] u�����kp�1��0�pUK/���'�ab)ȻJ/�i�C;*+\������;8E�ME�CW�� ahG�6�S�O�`�28�.٪�[Ɩ��J_PV����B���0��ux�^䁝�� k\�{��0����1l��W��:?L��ZCo8 ���F��A)'>�f����    �d<��9Oϑgr�s�6M�@!���	6_M�5Y\��K�&t��{M��@�[Dy � ��z��)�s�ϑ�?An��\j�'�#�s�g n����E��&q[�4L�	�X�E5ɗ�F�:\�͸}���{�9��u�/�����
�z���t�W��g2�T�`�zJ��.��/Q�u� |�������wǝkW=:nu�?pUo��o��D���w	2��V?�.���G����Cox�{V�L�����k,y��`z���l�oQ[х��:���ݤ�X<��K;�C��ʒ}�Y�'ց��%�Ki�]��]]��[W�D�+l����{��
?�ޚ�|��h���]]�,uP�)�I�d#Ϙd�Le�<�J0'1/,z�o,a(�K��_�I����.OxoR�^��bI�-͸�a�rZ���,¶^1�I�3ּ�$Y�	�����ϣ|�1f4%*)���n�z�\�V?/x��G��8��,�%����k�X����h��Gt��k����s�����DAx#���3�~��Y�Qj�:g	����01@-���{e#W�кM0M\��`���E�K�:�Iy{���i^I2UҴ�5���>�B�K�����]g�j�����"�y�f���K?��4���V��#1���h�l�YA|�Th	���u+AU,�a�ə`ާ�֮ns]�xxR:��
k�,f��z�<�����W�H5��!�$��HP�V?H-8��G��:����)�-˔�%C��@�z�;��I��3~�a�ǃc��t���GE����{\jIm�r��Ͻ?U	<U���
��R'l�6c~i�T�l�=�:`$,�K�f�Y�rzX��K�탙�)���Sm,����������{�hc��͇ט��\�a���(0���	��%k�sv��%�w�dǽS	 �u���h;Y�^�;C��E^�|\H=Ɲ�7
a1:ʞ׵���%��w��m�5�/�cm�N��?z����i�C;�\p?۬���;錘�л�_O�1��; ��R��������jy�1�����s�G�s5[���Yi@kB�+������9&������bp�hsxD�,(��1��b�Hڝe����b�b<̾�����9Wd���&uv�i�KE��8\��%�z���7#6s�����	y!��M�Ǖ?�Uo�45%��\&�:����<N~~ܖ�_FJ��l�d�Y��S�B����K��v�Q���=�x?Y���X�I�ռl�i�C [����9`�Z��X.���ͧ�l�"l��p�_Q�}�%����'�d�+�I��t�d8��ug肔��:}�M�9�����
�	�>Bm�u��W����Q�h9X"dNxSt��f���[[�y�]�e\�<���s%1�Ƹ��|L3|*Q��(��`Z�,^b��8:��Wafv6�(�`e��{'P��Ϋ�I;X�P���Z<ŉ�1�F��,@[�5
H\R�ˢw����9�#94�]�Ӛ�ps��I�D�ês�6���l�4���>�d�ʹC�`� �頠�rE[�`\�V? =ê\���B��S-P�-Ŧ!M�ФI�&c�^�>(�4��yZ�,��93Yw�_� /��]�P����1��M/Q˦igXf%�cv.��7!H��{��Cg0l�N AYz=b�~o���a��ˊ��C�����{C�=����s����{����c.���5k�Ͱ�t	^>��F��!��w��3�Q,![iA��V&������kll<;]a6I��w��KϩQ-�'��7wNB�@C�y� ^491��!�F���:�+�쨺�UH"�h/L���>@�+J��ӗ��a�`���˨�=����H���( K7JuGn�۬6+��!
՟*�ϒ_.�i�Vf��ƝIה�ʶɘob�Bn�+�K������}ϴsv�����䤨�3S�$��y}X<���='&��k�>V�n�i漸2J�$�4%j4����Q�`�6n�)�1ƤX?�T[(Q�f�<9�뷛 ��i0��V�����K�% o`���ZHMY�TM�����J��vT�G�P#�3��P�y��Q�C�Q�ra�Oa�r����2��Y��b!�-BGk��PEU�}�plހ���23i9�DeM# �vt�u���|���ω3t`�x�r(SY�aD��*]E��h[�\A��[w#�<�6+^β~�(pœ�R����~Q˽ �����ckzj8�<��y�cV]��`�jV�49���YF4IC�x�nR�?ƸZ�e>s�`�C��;�,�BUL�����F�n�[�?�ea�����(��Ү�Hz[Q[j!#)*���2\�`���\���{��1%ׯc���)5�U.V�"�� ���YU�Am�σ�FĲ�v���<��.���~Ȫ��U��5��!�v��.�����tE��`�b��%d��{��߿?��������|1v����O�N�7���ׯ���U�3����,��RN�;���oO_uZ��8�W�zᡧ,Գ����,�o�Յ󮧽	��6���p���E�����=y{�m���S}��������w�v�,_�/fƥ��;j_����q��0�ŭ�3����z�̞�ǝ����~p���a��P^���۷�b=~��5{ ��9��-���2��6�F�nZܠ��A���(@up��Z]�˺S���i�C W�_�j����\�(	�ez���(���@��O�����7�&�=4{/�8p^�/���0�&o֗��^�V�+����~�aΈ���"3$[��@�V�WM��V�0���ӹ|�����xz�ޛ����.�,�����k�[���o��Eo��rp�]���ŷ�O��f�[<Ϳ�����ya�F^�y��<D[�2�b�&���YJ�	n[=+c�*K�|)}�x���d�^ή|�Zv���8�"k�jK0y��(�Pf�>��{o�:]��$�e�E��8"K:O"�Yӊ�K����۠jH��h�]Z�TN���c8�=�u�%˔I��Ϧ�wB��:+���RA����v��#�� S��u�M	vf��qK��h��vg��w�T�`J<�����^�A��<Y��X?�~�N����PC��/C���I�F�@~�)���q(I�b�x�OM1(��d��l���S�<ೝj`	��9��N��y��T�lX\�:����k�'�N���`�]�FT�Q~%7Z�X%� ���X��IV
��Bg��2�h}��/�[ ��bY^f��ᨏ��V"doY��2�PU���������d����(�������˼ng��s�?>v� t���pYm�*oG�c�d�(	"�"�
׬�*�\�����ŀ5�X�7���Y����W]�E\�sU卣X�������+� ��A�����'.�%
u4�D������[j����ٴ�Q�1_y=!ƛY�NTbј��z��	M��&���xqN�^V4���H��n^��׳���9�
#�C*o� +�06-*}��	����U�E��8��� δ���r��]

�.��Q��6F �C�����GR��!��DuM��N\yjh+F�SH����m�JW,Z��̢|�(���"=�$������bj��F�ff嬚7+n?�1�۞Oc}�ѣN�!��畘|5C��]�����~����Ɲ^Rݾ�5I�̛1 ~����t����'ɥ�i2��R8�ayZ�y�{p$�l��1?&Y�S�t�d\ҎXzj8,p�3S:,��b��g =�^-}~
�Ŷ�nO+O���ժ�(#�#��Ă�At���)O��f�A��.8ۖ)$�5;C)f��yD���ז<�p�Y IB��P~��石k%.7L��o��M�l�E�Ŋg�s�,[J���͏X�-�YJ�g,T�1�%�Lq� \�d���"K�Ȓ�Qҽb�vN�3��14Rh,��/b᪓�?%|+�.
f�6z�8��~K������ܬl@��t��B�Y3u���4�0�X|��    ��2��(�dq���q��>/�1��s-~��*K�Kt�.��*��~E��jm�蚪�]S��]ˢ�����H�~N:��,���}r��i��T2l���=q�d�e�^q�%���Ylr������E6���Υ��l�Q�1�*���U����re*��e��d�+�r"��"z鈧�h�,���K���gs��G�c���lU)ͪ��N3U؏,EV���\�F?m�\�l���+y��xj�*f9�_(�-nT�m�0�f�u��l��$H�������Ǣ�x�23�_SU��tZ�2&i���ꦆ͓e�$yEg~ͦ�Α�B�4����0�Z��%���jŖ�5������c���N�w��$w�)vK:k�}6���5"ꐌ6 0ݴ*���C�0�~�,z�5yK��RQeM�
��c/�.�1f��;���vg<h�n�5d�ş��3��z�YU<s�����*&�����VV�V_tZK�,��}d�´�! ѝ	�&ae��Ae����#C������0���� �N;,����+]Be&�\
�LI�G�����(����f\�Ɛ;^�a��1���8�Sk/�g�����J�cmx�b��ֽ�x4�.c0
OG�T$���jْy�GVR=ٱ�:��g<�0M��]Q,��jH����x���)�f�TC��(ic��݌��`~���Ü-�ڄ�-)ξ�j�_�e��m��*�fTTM�viZ�Ўj���[z|�"�j����l�Q��*������;�Z�N��]˚�Hl��Q��*-��$7�
a���4V�)8"7H�p������+��/�6E���pm#�7�er]���sѬ0�;��5{FJ�ȷ|My�C�,[s��')Jk�n�+[s�Vu̇�g��Ҵ�!�����GIr=
�ި3wznJ�E�k���!�1'OXD)�ڼ!��i�z!��������V��Y���v%���(�Ӳ݄� ���?��x�:+b`<+v�a��"��K
�l�p�ސ�%)��n�\,�7Y�3�/�v�ۮپ�U���u�#�G��S���0X.Q�؏�B�i�k7Z1�}*چ�L���SIg�TtV�=8�zEN�qy]�:"Pdl�e˦��9>�<�~�@�pkڃ��������(�"T[�,�ʛ�i��}�i�C;���|��Oۥ2���NeP���w�tO@Kr�ј� ��`S��3�V��i������	"���`������M[�0'�/��+�E�T|˃ٴW��(/1@w��m�E��1&�13΋{����'�h��[�˲�'k�aU�eMoX�&qC�=]~�����:V�c�$U��rw�_iZ�І��ӌGcx�n3���;O��4{���'ϣ%�5a��r�Sԥ�DJ�~b,X�Vo�uk��uf@��p	��	6��q���6&�u	0 1��0�'��e�\U�,Ɋ�H��	l�����0����?~8 �H㹨YZq\��qSS��a�m�T$6��	6 �a����ƚ�$���ҊXS��~���SR#�-I�q�"�����y7[Ԧ���dZ�e�\������rkBaZ� \tj�Zeʹa8�wX~�`4�����}����k[6k���97
�T���,-��ƦVg&�\���P��f��3�Ґ�e)�������'D	��I�5�g>���*���T7?�T��VX=�;�L֘�n8�Q^d�WVJY@n�{�װ�����=�I��<W����i_\�Q��O��=��v�d�)w\�3m+M�`QZ�J�۰mI�e�;���V?�|Z����=;"�CP�MU�S�a��`�j����ܒĒ[����K�M3��#���n�9:����Fyk8��}�^�y�p�`Ew �plO%_�.��z��H�Ye�Y��Єߣ���x��3<`��=_G���+Lk#��hF&�T�O��9rYi�Du���`���xtF�QVˆ�L߮���ح�N�:�a-Ϭ�u��e �d��v�<���!�w��gwt�e{��}2pȡ7u<�;��� +ͦ�
;��ɲ��:�#�?��}Sۻ�c7Rw�2�ZH��>�-��b~�٠T�T�Q�{��$J��LD�]�)`����Z�z|1!u�_cݦ��6�e�+ct���k`k�4�Ϭ��8+�%$�7Kf�<F��&�E���:6@�婪E���]�x�)kMK���=�J�� �SOg���yG��/?�7?,�+T�8I��5���w;����u��sL���t�H��!�ը^��\3������TZ:nCxI�u�Y&= A�	�K�nauZ!$��!��O��:#B�wQ�*#�
�%|.�l�yV-/ջr����f��P>赆�O
E�ÔL������T椞 p$^���	3�?y?�L�^��$-��tS���O"?mXԖ���iI#��Ij?��tiߵ]�^rڪ%ևR5ü��Z�V?D"��t*�V"��/���������]ݱ�N,�Z%-yX��B˗�kn�#�
�&R� ��ܵ������F�����p��	��q����3avt�sCJL�C�C�#^|��o8Er��ڤ;8�)]���;{�Z�0�N�!^��`�����4ȋ�5�o{-�,��L�mu��0��� �B���ޕ{��[�DpcR�^����Ik��6h��Y�OSg�,M��Q��$�?�T&)*U�@����*�^Pn)�p7��y�MI1�F���v�D��IJ4����4�$TS�-Cp�V�oA��s��ڄ=M�^���hVJ������s��0��%)��޳�!ؽD3�^���-�͂�g�2,w>�ĮUe�ۜ�i�������:�So��2��3c��*�RD�օ��ܖ?p��a�	�a�˔�P���!�x4��C��:~��S�r����-�\��5��2����b�VcY̢ԦN�Y�DR�
i�m@�\����,@�x����f��K �v�*��Я�f�K��r�~U�c�������e��fX�~w�niZ�P��֕:����<eW7LuW�t��`c�3�9���A��3bVz�TΗQ��v��棃V���QP����U8�ʷXr����]�s*�t���e�\"��"ב�w�.p5�\j򜌇NK���ۜuh�e�:y������*g�� �KR�Z_��0����-������L�Zb01<�P�W�/ͪ�QTѳ��u����6�]]��]ːLt����k5O���p0�v�)O�L;�/B5kj*V5$�+SC�m��a�Mߑ"�{��U��HJ�2���j����v�y�T}+5�.K<�:[Jk�[�Di���*�#E�J��-�w�)ΪR��u�YbŽڃ:����i�i��Ԛ:~OJP�8�q�8z63(W�;}�����V3L���ٳ���y<�hJJ�Fɗ�!KO�@��ڰ[�ǀ���n��ڰL�N冭a}�z)���jE���(6�/ �^<hzC�S����ɴaPE2��mX�.�4,ɦx*[��"*Y��JT�.�aEN^o�ʦ&Q�1�yȃ=��P��-�B�����'-Y�t��Zx��ً����,>�a�4|� ��o���l9��S����.�'�|�.cK��Y���$����D�yp��S�2{��yg�Z5?�����;�;+O���w��GB�h�Gސ��P��=��Y�Y���
�ITGj鴭(ަ��}J���F��7y�l^��X^�ְ�g���;�'y�Gő��kB���쇰�`��wM���y�l+�pϪLwy�E�� ��$�M���0l����=�i��U�#��6�����??~�O�SPb�I�4�pPO�V>��adh�{Gx���Nߟ&�hK�ϛg���k!5���<��g��![�!�Y���=�4�~h�dF���5�� -��HM�m��ꍺ�i�C `�� �9�� sɊy禔�i�C `��a�����x1vڎ���щ��RMVr����<8��AX�b��#��< ���"�SQWL    ����H+�dKɑ�[�n�$���yz=)7S-�B��{�.`�~�!Ɛ|�g�$�W&�{���|��f�\�7J�ڰ+B�w=�vVYgy	���$��kD�(%��f�!�X����,� m5�8�(KL{��؀�/����0��̒Փ☛üt�������F��<Įv�+�-Un�����u�A銩������ Յ�
�6�������U4�YTty′����u����~����X�/�Ќ�'��ΰhP��,�lJ�x%S�-O��U�)�Eݲl�D��ڒ`�ŰR~�m�gd3��)vtlI�wE�j�P�����|�u����� �B��h�`ӅAV%�dI���(�vdL85�|J��8�b�*��`��d@����X%���n���lK=�>�>i��}a�f	�g����E �ݦP�h8(�Xa����3^���M�:=3�4P&�=��{j��۪�O��)��fZ��O���e������:�i����͝��ķ�<�&�3�LUC�3��
�S_��S�@�ө�������q��&FP�Z�R������ S�qp/��W�^��Љ�A5�T58�=�Y�V? -8H�[�yi��K���dK�=�X��3!��{̞mh��>L��ޝ���j^��2������xwd��Ic7��uc�|��eEݓ��+5fI�5����&f�J�ll5rk��k�@G�jʶa�=�4�~hG5��g%�[��i��QC�T�#/��ya�s��u�2�c�Ɔ���Z%�8���Y�qFf�8���An��_�6�wzΣ��=���x�i��U�;��q�:vM��\F�ؔ6�d3��3����"��7x6UtE��Z�}[�mi��=��ǳ����ro��Ϳ�/�:�j���嬽��t�G���n��ȧ���k={��;z1:������GO�}K�a�#Ssdy��{}D�5r��YGO_~���}w�=u6t�Z{�y�=�����/_8����������WƉu
�_8��n�♲P:��`���>��gG˵�rT B�[=�g}w���3���'=��^/�^���中_�L�{�]�����Wǽ�w߽�C�5�h��`��t�z�sTǵf���z#X�I��tBWo�Z��'�Z��k��훋��bf�G�B=|�o������g��^,����=�kG��\�}�L�>��L^�Ƚ�κZ1gd�h������(�|ܢ�����o\�^Y�������~9��u��H�߼��AvN����h�z���[�oA�ؿ�_>_��/GÖ���������+�����=�6��2}�/�O^������;ǭ��I��O"՚�������J�������|�����?����3_�oη���O��59 ���7�b��h��.\Z�m�����A��0����{ �����O�;Tj�k�����\qZ� ���[��,� ������@z�*eEr���O��ݴl[���mɚ�'%$ył����WUNV)��\M��5E�b��R~:6y:� 7���%�˞*�m$R�^m⯗>�d�LU�I�m�<Օ���kqM|QY^X��)<[((�/��7�S�P�����u����ˤ�il�4�� �n.!�x_�충�Z��뷃f��f�(@���{i-��!���5j�,&Z�e��TѬ]�5�i�"��u �.��QZ���=qx0��߯����l>���R�L��`��;G�}2ܚw��1yGn���k�0uE2�Z&��Va�[�f��C7��Y�V?� �s��̈́E�0w-5#�����˜"���2;Y�O�P��Sr`�� �͇P"�-O��`S}	t���}����\�VmU��xjm'��`�Y3�,��B=�S��#�@���n�=W�4�~Bt꣼�q���ĔTӲ5�K��re�&Nk���I�^���=���lYɚ3PE֨�;fuU(���a�_�ˉ�����_��� �x�&��Vq��<�Mm�0�,n~���6�(��mlY��B�t�Qȓ@YA������t�z�)��'�P0��>2M�}b����������B�ё�Ŵ������Ύc�S�Q4-;����Q�̤��S�a�T�psj�	��i�n֜���P�X�PX�|H	!�ŝxu�G�,i��W4۩�}aZ��^�*#��_� (ܿ�@eS��Uݨ��$|��,>I���c�\D��:������?�gL"+��9���
��l�[W ��q��q���PR��+�N֧qRg�7�H�a�%J�JFC��ڿ
V��$c�eA?�K��4�Uuϲ�������mqR���Vs]�XK��{tZ(M���nfC/�;)�زVb�X@N2Y�E�].�E2q�(��h�D�
�$)` ��[��_�2��$��R'M�J	��\�'X]}I�LλZ_EU�L�.��-�,_�|oR�>)�]�V�
M��|����X��4k[�*�d�O�z�y�do۞^v������Q���w�OWq�k^n�k��9����]X"^ �����O^�d�����٭���5y�1kl7U]�(5+�5[,N��~a��5I��쏁��`mn���p�x���"?EV��u��� _�Iaj� 21J�ɴ�o6��iw�W���F��\��¶���K	M��眝a�H'�
FXm�}�==N�GH���Q��xc$�_ ��$���#-V6��Ɛ}d��B�ৄ�T)����c���Ql0~����4�c�gz�aA�1b�\g�(�c8���������LoC���w�o�a����p���uS�����6����"��TNU��X��b���xÎ�-���$%Mș�֌���֩����g���s�1�����rG����nٖ=�4NF���)R���a�d֧nK�ʧbrT5Gך2�&��B5��2IiZ�D��i>p���)9��};TL53���Y��K��vT�.E@��A��m��RB��Ўj�ۘ(��1�\�kP�kДkRK��Gv].��vZ�"�-@�Sb�I4CW�:�.@��q��2GN�y>pX�AL��2z!Q[�,���V�>--�|�wڤ C�C������1�"�(�IAI��ɲ��.?rf�gy�bFiE�8��>ob���˺�]�w.��4*��	s%2���]�Y�����������:���7�Y�#�Cn;u��ٴ%�o��[�ZJ��1��Ԝ{��Mk�H�)+w�*Ϊ�)8�o�S��y���M�"����a�w/_Q�V?Q��"ꃈ��ET�Q8L�Ա�����! �� � �� FG�"Q��� .L� k ~ ��`�Ҵ��(�8�V? ֋ e�d�dx2�œu�����H�X��|��<��Z�SR�h�%�(F�8\�����7?�c�m� �\gv��4(gA_c�&K�V�-����;�v?�;��w�m>��J��뼇/(��?c��u��)�}�Ir�^����Ks�J�.:�~�ܨ�U��0�xi�.��d�(R��\eW�HH��5)��=�3�������:5�AG���'�K�Z+@ ���m�q��-1�@>V�\�o�W�K�R%��b�pY���@�m�N��8�iF��f��f�7A���6�ό�2�<�6��s���JV�޹�~��{�`^ �����R��{.dΠ�r�_���Ur�nVJ�Z^j�,yx��O�����=�;�
n��\�V��BwH{���O��7,!RU������Q���^���M��v�/�r�XT~EѬ.AI�\��T1j��rX���$(X�n�\��j�2�9ۖ�V}}3{c�)�Z��g
4��D�_}�wp���7���� }�t�J:W�q���%l.�k��7�_	�+B�m
r�w'Q�Э�i�vu��g%��q	ر�N��s.t�o��U���_�Cڣ�>&�nh�╔|�Y�����g�I���-�M[<���w���!|���@�kZ�M0�rP��˙#'y�q    =���Pl�BT���G3G���Xu������z~�?�e�wlnr�{ޝ.C�[}�]$`�����ӧi�H��X�]��ｂ��Eг���qnG�%�M��әyI#�hv9֓�U���(4�a��B�-�!H��	�,Ф�NwG��
@�=�ՍS��P��Vix[E��_��3�9��Ú�
7{ʚg�G�@m&Ld�^$�fK�ݩÎ.[_��{�+/�;��2�f2.�I95ߩ����u{G���k����z;��3�0-fY��3�K�ꛀ�u��ǟt��L�0����gQA����BN����i�_�����Ui������d4&`�p&��E�6C���s���x� �C����a=e}th�G��\�u��n���4�m���U�G�wA �?!B2W�G����U2�XY�3Ǿ�z.�i�O71�a��$<X(t�����$����W�H��dѤB���bE�}]�O�R�O !������*�n1���z/^�d�r��Z]9xEs>A{��$��\�ȳ\=��+~SK�>��������j[�~�A��7��U����g���\Pi&+����0�r�ezTC�2��(WE�d5�� �U�,y��Q���%�"��Ks:.���)e�=�<�&����v>�=e��:�����ݫ���;=�辅����ݱ�M���������L����?���śE��K���������?�����m�G���a�Q4bP�"8q��6l>
N��}�Ưnß^�)G�:�����)kp4��NOF��͸_���ʧLw|��3,/�y��N�&��`�N���k� oj{4|�
���K@�sO�@!<6���)�P��RBk��L�󏒉�e�\��aV�0��ۂٶ�����DsЬ.\���w�B.�n�M[�[0�;D�侪x��lh�8s��u�A� ��5��Ag��Bm�5r��X,M T��u��8���O^L�<y��%�[a��#f1��>;�~o�{�>��P���%�r�$Sz�v�e��~D4��]�d������P�=sy ���>,����K*���%�Va�d���2Y\ƺ�<�B�w���uR
5��)&%�#���"�s\1\j�,L��H�vt�� ��^���%���e����g_Q��i�5mY?�?��Ok�%|2�{�fo_�ث��^���d�ez��6<��@䢅F�c� ^U�����GY�A)�J�ʫ�K��6J �
��(K;�^��e���e��E����
��� ��7���:���Z�t����`�D���.V���o@F9�˪7f-����Q��P�ޭ�i��
�}�I�Ŏ?�����Z�.��x�a//0�?��t^v�c��3�Ut����M]�~T�2�3B��
{A`�"PBV��?HWS��%>�)a�3�I�%(�R�G'��zd�L8{ G���0L�?!qY�8�$��H��4�ga��r�P;t�H ��t�5��R��T�)�Ӟ�����b~c)&)�!\ ^�Jc�=z"���7�0�p��Ed�4��*&����D�Y��K�/���jz>��b��l�j8"�5@.�7�~������Ay�0�ʹ؜۷[/u�o�J��}��5�&�r�:� ��Y@�(�F	
��y�� ���#��_^��?;����3�_xiJ���������`��F/�IYu�:"Fߩk
�yk"뉸Э�	��`���Yw�[�7A��u�x�U+[5����}	�>���L!��tC!C�+cJkS���y��(N�C�Xa��d� CI����T2��h��<�����0m������{>=K��*�`1�^w #� �w8P��wL���#P`��tMf�ֻ��qUCi�~��I�#h��B��ߑ�F<quJ�x9_(oT
6����b��^���Dy;�0y�"��N�ޭ�	N�K�b.�lX� N�~���DZ���/h��X��� �T���h>\>��t�T�n��~�a2?��_�?���ӛ�E��#rbe�ǚ���8���~��D]��67)�U���Q���&O�^�>��3H��w�����hx�c�O�C�y���Ƿ�o����Q��`�e�*��5��=����8�>�W���R�4�И$+Rݨ%B����j2�5�n=!g��E�4[h|j��p�Z�/c	�%mxY��(�˯o�A���g��lD��ۘ�8�b>��ʽ����yt��j���0�;+guRG��uM���}�_�Vߴ���4ReO�X��S�޻cDoA��r��`�f���B�PH���m�֋4J���f1I�$����->�.��d¥�f2�<���V���0^,%��LP}K���u���6;ǸW�/�J8(�j���b�����T�fۘ�D;�{�S"E%������ ��3v��Y<{wW>Z������yF�@����^s�V3�%�w���~s�88��߃̓�+w���4��%+����oA��!�Π�ޣ�V�4��dc�)�id�����%��PH�ԭ�i��H�G�q��B{wV��К��_.b;�%^kSa�b�k�	8����m-�G�`oؖ��h�F�����Kk~e�F/�~���h��h<������5�b	E�*׋LS+���!�Jev��񥊟�SP�K��T]�{����2̿���J�t߳ c=\�E��	��S	O�<��!r+�@ݤӼ���j��Z�Ev]h+��SL�I�?(UzC���-�M߲F��߿��m߷La%-�5�:�k� _�v-v)%.jY���x�0�N�B��&�t���s�.t�0��M:H=Q�����������S,]���~�9Nf�����Mt���jd��W7�)'����¤r�TR�G�t��n-r��x�0��s2���]�d1�)e/CY�K����S	LY2v�BpA�A#z_��8'ʪ��R4�j_��!��X�SW�W'��*g�5�p�.#[�|���!ģi �m�N1��d>ь��C7j
�1P#�:/��H����v�:��Gi�b���0j��*yx.�t�j�j[���L_ԡ�"�&��@&5��ތ�:�RE�x�����QuU`��AH��(�P%B%���(eԘ�%�5s�m� U����+ў��^�7�x������g��	���y��LL���h�v/�S����@�6;��"��������1cO�E��1K!�J��\��h�k�8ر}�Ǌj���+u�oJֽv�SgD��-�1����	|���˳�)2��#E�e� ��x,f���bQp��5����"|����?n�î�9n�m�w����r�Z�#���f�#<{�A�a�� �EL6������$8��y �]�߅n�M[��{}�Gn�,j��p#���n��@�|��t�$�G2pa�Ў��$�f�~=||� ?Q�4�,�]�4mq�{s-6J�P5sp�$c4���`������v�����J+�/QD��p�$�T�
�/AS�^FB�C4�a"#��;qj�6�XBP�Pd��]��K@��}��!S�aQ
������P<�PE��[�����ŵ"�<F��a	��J����f�,��^���I�_Õ�"��tPm�yuD��[��np'��zն ���@߻E��<DvǱ�/laP�R��̷�m��tQ��P!K�ܢ�.d�-#MbB�i%���:��O��1p��R{��k�A19ʿ"��ќd�!�]��+����� ziE}O�v61��t�{�l����M�ίQ�o�=Is��u�@��v� ��ҏ�!h��v�S�w٥ب����"y̳��ӧ��QVQ r��ԏ�6�@���|��m:4��.��Y;N��v@�4ͮ�0;\���[�]��B��&8�g�W0���{���M�r}��u��y�}��A�c��h������~��3����R���o8 L<ehʜ�@��������a����h��.+�A,�f�	��F��Eq@9�?���6��)����\���/��:�k�a�ù���H��7��Г
|	�E���Vs�B���n�X*D�=ߏ�mL-��F    +�����Z���rT-�Լ�ƚ�hV𨐼�&����<jI�K)����.'��4�9�\�䁅7Q�Z���8Y��L�߉��%24(��
��7�BS�2��z=ˍ�YЖ*ܳ��:����ԌuOH�'�G&�h�C�P��i����>���3���Pʥ5��O@��c�X�#S���n8�_�.�p��H������b<��º͐�?��^2ג9�D�@�w!s�[}������)w���<�(ݵ,��m�B����\�Y�ѫ�qv���q(�"���d�������J�4��>����bi����0��h<��2M���9ܠ�WQf댈��7���,OJ	P�1�1�ޞղ��>���4o����؛�:��䔢v����I���}�9���^�A� 좲yEa'4��@���=C�Ce0�>M̈́G&���cٿ�E���·����=�0�7�7�/	�@
�$�'4!���Ǔ�Ni���ޱIU�hG�r�,�9�����-+�q\�xj��=���ܾf�[}����'�]����/e���/
��&�yV�T-��q�����b�BQOD_7s2{d��_�]`�d�dxA�؝|�Y��9��RF��C�}�)\2;�B��$���V�O�]�&R�V1�������%2`㗚��W�l�%w�z��������2/Ųro�^Y���8F۸�����*�ڱ��'h�V��&%���Oh��J�Z�<^ψ���T��r}�hZmJk2�0z�JE��Ŧ�V��j��۱<�ǽ�ɾЭ�	�Yw��2�,Pp#�Z)��Q��	f�Ѻ���R�!��TA��3N�h��'�`���4���
�4����d.��)a��s�4�G�M-b�r��M��ǃC�V�'��G��L5��M�U�x����dj�r�Nx�-��A{pԦ�,^/�a ��X���nJc��!��V`P]��.?��Ľ�!Z=5lfs�:�W*�>���8P�6�w�=#j�J��2�s,%��w��ό�^�#����A�<],̊C�����I�Fۂ��h�����P��]�!���(�7]������n�M[�+�J0����̱��д%� ����O��$傈C)#:�O����+�Y��*��2Yi�������m��g��x�D:���7���!އ�������3�R7K!dC�H~��I�7y�Y7���Ď��k���U*�`�ȧ/R���7�F������l>A���l��8#��,_�^)*u�o�C�{����?:��}iSU�Z�X��v�}R�{֊Ń��@��5���4A��b�VZn���0Z���Pg�������>�G�U2�P�mc`�������d��m58(�Ƈ��d���;���'��3|�oN�Z bmډo��eܦ'�N06�0K�.x��A��A)2�B�p�����"�)����N��PR{��8�o� ڧ9]��<�C�#:3A�\�[Ȃh}g�R�00u|��p�����l.
�x��E�$����ػ\La�)�w�����7��~���H�/�x����t�8��-ˉ��Ԏ�.#@�zSc�d�L���>�ԭ�i�t'6�vw��? ��(<:�Lt���{F^�;�t�s=����ib��KnXۄ`�p�)z u���6?�Ъ�(�,P�~GD	$V^��l.��<�`b��A8�uZ�֗A��-T��t$���d/��y�����{<!���؅��<O��4�+�7��l�ϝ�'�� ��f���餕B?�yL�XʩEG(���\e:?��4������#�!<9e�4ix<q�;����?�Oݑ�Al%H�)O̿Pe�%LJ�jaP.-�.��Z��Pę{�m�WmP���M��Ũ��p��,Y'j�^�����ŕ�i�Y�����l���k����M��tM���J�6P|����ꛀ�uu�?��^,�]�Y\�g<v|F�6���d8?^�$�:FQ������C�UZ.�U� ��$�xct��z��ׯg�Elfa�nó�e�4����@�	�J9L`��2��Nh4�mp�� nԏ�9 G���}��c�ʍ��2W�U$�z���Kzu;�A]LE����#h{ն ��"�J�k��������B(�s����L
��#�%q�YZKF�il2��q*#���L�$��U<�B�9��,��)h(D�x��w��z���,�ڶ�5ׯ�E�߃� w�"+u�>�y���L��@�p? T'(��<R�&�;Y���)u�`	Hi�|F����N{������Q5æ�[U����^��vj�lO�+���v�Y���Q��c`�:���ԪM���]�g�����=�X݁���7����&�B8�0fs&��|�.�F���6M���ۻ&�]����||�;c��B�ch:��{���*V�X��́<�w �+u�o2�=�pT�����&g`�Q2=�O��O���p�.��VT�2��
��q&�� ��T5�xOnM
��]��4#Of�	{��Y��¨з�{��>}
�N�6���M�T���3���X��+�6àG���"A���\z22G�-տ|�����x��.��~�Į�*�?L�drze/�L�¹'p��(�Q������h�׳_�"��W!�`Ɏ|ׯ�ݕv����?8'���T,TJ5�R�>]�R�?U����,����}4-[�}�եn�M@�n����3��m��֜���p3r�/d�A��'�\eX�2���0���3�(��)Q�
�+�e`
�9ũI�.~P�S�C�A�b$�0u켞)�Q��� '�����\�)�?��Ge_�{<#Ь��g��"��;���y:��C� �2 FZ�w��;Ϥ���ȜP�5���RSP�]TBm:��Ey}��Z���dX����x�1f�S=AJ�c���'/B�(euR�@�Z�q@��m�X\�V�D땈���>�T4c� �l�v��?"}WϢ�A��z�9��߇M��O�X�|�l9Đ�3��z
�&�BS?^�!��`��.
�y;�J�ue�ģ�����Y���j�B���O��2mYp�@���*2T��'�s�z��9������+8�G�p��b�O�1,�w'��y��������I�#�./��1�Z��9����ުo����Sǂ��3A�`���ߥn�M[���0���|�0�'A��8�&}�����sӶ}/� ihM�I�'�QN�B2���ZƱ#P�A���4^�[ �bPvC0�7<͋b\v���fi�s�v	|Ȯ�c�3���$��x2�W�N�me��O����Y/-�jSy��<g-ϩe&ގ㚖�V�V��?�0��u�9F�Y!ϊ{)�� I.q�^.(�E%������e":]\�QX�o������&~Cw�M�U��й&���С���;�4�<�H�M6�;ptq��A�l����ώ���\Gێ�Ø�����k-t�o��U�mY�,d
)�a`�4m&�)~b���0�\,ZJ�ky�#R���71���)����r��F05`����>`-�bm9SL��ԭ�	h�h�!��ǩr�M��L�2��ӝ��֏�cB��W�Q����Y�i"3Q^*K�D����j!{���b�+w�+��Y��|�pq�WPQ)ʇ�F z��6S�k�h�M`��?�d	k�D���q6���t8A4 BV~=C{�	\\S9�ׇ�EKꎆW�Q8P/BV�����^˧n���ɩ;b�=���s�#��8��3:e',y��Y윸���;��CNa�,�cB���`	�<��s�m�u�	'p�Ql	~"�	�?9�)j�1��q�s=f�����3cVes3>/i�|~��<e�0h;I�	\)�^��!�m�g��U�J�ꛀ��=���Q��3,��p+���Ҳ���H˘rN��8��2��� �Ç�@ƿ( �ɔ@���ՇF�4qt;M��؀�N�>���c��M����;r֭    �	�Y�àѶA�|�ݰ�����V;�'�$����]%�H��Z�,�G>�j���YI0&
l��(�lH�u����f`y����ջ�7͊��k�k��&#v[}�r:�Ĩ��k���0���\��2���Y��Sz�DJ�������w�Y/i��1nC6���wj�){��'ct2��G�׳�������o@����B���}o:m@�7�Z�]�7�cYw�]�j[���^���f��A���퇘+���y�2��)��4V�F��GiԊ�ැ8�s��w�gvt!��Wd2G����(W�e�S��Ὄ�,�ʹ�b�8��-pu�%N\�O��Wi�V���U�=�u�;�`�[}�k��X_���v�^d�QG�5u���&�X��;j��b}9������*#��ك� ���۱,t��i�K�w�[}�m����"2�r���=`\�G0AL�s@5vA���4!'5��H��^�{��+�T�%p�5��k��
�F���@~���҃J�$���`b�m�Ѣo�xMY�,�����0_fU\�N��*�Q(@����nE;�[��<�e����SYL8����J�꛶8��(8%�� ȷ>9@~��p=:���8��� �������>���xP�G~�s�˙#�f8��,��-A^����2G�"c�ϝM0�r������c ���˷75��Z�2�㯢B��A,?-�I�[L�;H�b(U�j% 4,���A5���������f�(����DVq�h�ބQ�B�K�-"��7��IV�.gi�%����8�I8�鯬2�pq���R,XR^��B�r���Qu��r�d[8�M�����jFj:�2�oa�[����D�h���F��g���{㻥�Ӫ�\�z+��}P���h�>zgtx�wg�y��F��:@l++p���pC��꛶8+�r�r{���(�fI���F+<��[�  �7-[f���g���]�g��N�e�ץ��5�J3i��Y ch�LV�Z�G�B�ra)P��Ғ�W����_)Ǆy����\���Л	�P�j�F�%cd�y�����*<�B�r
�\o�:���
��t0ÄL�	��UL��B�K��ء4)Q�a54>��U%��+�����k�EQ�ӹ!�P��,6ފ�MҾX��p>YMg$N�>����W��ꛀ��]V[ Sj۷,�<�{q�"1����ĥz��/��v1	���j�X�A�ͩ��| !���q�U���?�/��H�4��ˢ~S�~�H��N%֋�9��*n��R�#5~*�]e�y@�FxK�Ƶ&G�|N����#xj�h��+4�pT����^����\�13�xU�}�i��τ���%7H�#�B,��"j\���]&�l=�/8-i�PJ��-Lm�Uu��m&~��|��	1�n�M@�g0s3f����5nmDG�a8xR�nʙ6�ka�E��Ԡ�ޒuK줤�u�R�)��L{�a�[���<��F�g9�Gkxj����/�֘����$�a��M��
XSVX��Щ�2C!3��xL�@g�S�@��<OXH �$�L�(>k1������W�4���������5�hS�yl�UPN7^XuD�����A�>"�ԭ�	����e��|��G��$�T����s�F�WH'Ƒ�ܢ0>Q�Ĩ�1���,�<�V`����X��-�sŢ���}���jB�)�	�����
A���/�]�5�z`8�\0�s��ú\��7�k�����b�́����9z��,-z����%��L�r��t��s
ɘ8��q�� ���1��Bw�p�e�2�����A��g_��lr+���q2�A"���^���A��[}�k�����m�� Q��\`KT�sPu�T��~gc2�L��`���LG���a�ň���|�uZ�ο���Լ�k*a�6Ζ��.���<��1�W�*_��4�/�R��X�J��&�S%-�9d�$�A�$,c,���`�.��n�6�j2jr�B��D��+�z�����Ʋ2/�����P�@�&:"e�&9F���Jڼ�>LL �j������m
�E�J�u�Y�n�M@��z5n�}5���)�{V`�П�Bkr%Aq�q�����$�u�ouK$��{I�m��A�y�	ߡBU�1���^�&�D��K���:o��J]�H�ֺn;�{�����n�>�i��i�(RH���w�gZ̹C�W�WmPm1� (E)�î
�JAT��zͿ�X��J:Q�� Ew^>����Y}=���-j)V�A79hC�N$�w�o�-��V"�hE��K#�/������L�zv���~���G�x3)Ya�hd��ն�R+�K3���&��#Dq3�@q���J�꛶8ա/x��p]��J��t­@�kM0G�<G�c̑}�9��ǫ��Z��/��K؟i��pa��FղŃr ��h	,Ett��`C̱|�G	��L!�g�wk��]p������[?���#U,Y���n������`�u����A���j'YN���z���8��·�����dq�>�Q�,���
4��@Xn�?�^�-@������s�y�΢��A����h�V�;���- 6*��e���E���(�����=jzc�w=��a��r��x��ꛀ��N[䪸,�^c�z�~����� )��`�R=�[�s�-���M	�y�˿�$��`HZC)��lc&߲��	J�ꛀ�nP���Xd���/�8����rS����4|��i#B�BC��ڒ��XY
�GK?�����D��)��8jI�#r@`3ǿ}��R��& �g�v�0Qî{ S�z���Ą���4C������D<�m$��A�y��W#R�_a�n�^K�b��,�N+z��������,`p`<?n�`9��)�X��V,S��*�U���{Xr�q^@]/�^��C�΋�¬/�<x�%N��p��_��^�2ă�⡀�wa�b�`>g�m\��M!�a��Cj���
����*v����p[���֮�],T웶���ݗ��7�|�v�S]�7���
�zX��
^�P<t�*
i����/)9�g-��D�׳�a(��V���4��B�;F�C��D�X�(�RT�>��;O���[��%��eE�6�Q�(�H��7���N'���5�?n71�'z��zA��2�)èDU�`>\�5�~9l6g��Xg�,2���o�| ��j2��/�*��-#y��A����g��"^�`�F�r���(y��u-���	�V%�E��� ^���.���U��
�Z^���C=�	��w,gGئm���w�[}���֖��~�>� %EX��(-�4<��H�/�q�Iy9�׳�X�L�eM��0�P�!�td�f�%���Wqz�H%���m�>���4�å�
��q�a�J�0�%�b�)���6��[���fGA���#_W�
S:k�s�E���T
R���e�X�Зoq"�̹����),Ι[9�X�x�D����:�pC7?��� S���{0�f�1}���ծ7�ÚC�\�%Y�	L8̻���ꛀd�Y���)Z(��c��Ցʒ�P��Y��]�+���e�U aۖ�&v��/%� ��P)TT�RlDZ��2BT�@'��8Q�S&V�Hkr߲�ZZIƗL�Dk�g����-GTv7
12����KQ7�Io�Y�S+���_{p��[9����W�^�,��L�n��-PG�h	rL�|vb.t�ob.$_r���щ^�J����'��-��cY@�Y%�`�os����&'�;��E>�:�+��x��l��떈K��/��WQ�c������P���w���R��^�` ���,�������rGC�~~�^K�6���sn�P�Vߴ�y�i��ڵ�Ɂޑ��R3��Ѝ
���N��'�*�� �G2�2of�'�`��~D�*f6Nt@kO�'�YLP��Bف1,#���i���@�v�zVL6Q8N    �xA���\c$w�$~��I�J��+}���g�!@�znX�Y���,�Q���R4'bO�!�|H:����}8>Nqؼ8l�w[{��q�k��GDa{�w��R���-��+�G	W�! C0�~�J���8�Z-�d��%\���Ċ��A�Bo�~:�V{@l���b��H!JM䄖OTK�sL�̄g��,��	8b��̥���o�	�e�0=_�o�]�����rUf*�LIl��2�?Ma�2�s� m�B]yc4�T�T3��]z�dL넏D��Y�h�S�7bq��� �>�^"(�
�8U�Y�Kɜ$��o%�i�\ְ+@cڇ��`�m�3��=��$1��Eg�bN���I<D��Đ7�.$#�ӟ�d[��������֧�y�����G"����k��6u�Ūʖ-�mKsU��7�\<����Џ�<lDYݶV�u4�*�G�Q��*Eg�|I��RƑ¥��֥Kˋӵld���r��V��c؞'\W8p�Y�V*ҰqX��h�k�����7���$�ȷd�n�!�Ύ�xc�|8B<8�O���/�.Q`Z�'�@��#\��?����>z.�W��}	�1=^v�x�/�x5T�ZT��=O�2�1�>�~#qlX�#p�X������?_W��-�t���/�;�5 %|�ܹ���� ΁�5]A/�"h���2��ض�pu���q�,>I�q\�+	`D����} 2���d�c�-K�V��7�|�ܭ��z���7L#`����0�������u���`�S�虱�L����szA#r�J��ԇJȑ?�m�m:��Ǚ?w8�:C�+�&oF��y�'g��#�C"����Jc]
t�6M[��*���>h����|��9&�w�E�ջ���Ϗ_!����|�u.�ζ�l�h�?{X�m"�Q?��:�-������mD��6U�u�Sώ��=�ܧ鋳oi§����b��PlT�Q���ms�Xe%��dN�������N�ŀ�1���F���,��Qw"��yg�gq��G�n�M[�*&`ZkLu���ͨ6����EI]`�Ly��{!z���Ǌp��C�
���zL2��XD�}>?�x;���!x���Q��|��5v���g����g�7�/�9��\�%�P� ���r�<	Y��"���7��>Z3!���cG|���eg9���n�M[�+���e�Fs��v�?�vC��S�Oh�p�ٔ���<��^�����҃v�����UHK�]%%>�g�H�,��H�ƍ${����+�"9W�AQ)�*���.���a��
Y9��I<�PQ���/���7q�������S�c�Ԋa��&��WGQ�����ã� �R��dW���qɧ�_e��2S}!D'��~{���1���)�h�䤅^g��UYG!
L&�B���1
=n�`�2+ndڋ%�k!_%A'������-��t],�!n��\�&^�HN91_grork۷���S���M���p�d�f>/��@��q��0��޵Ϫo��ت��Y��
_�����}����N�f0�hV�
^ ��qv6"�7H���QB�TD��/����R��;#j~�`ZN���YJ��`��n�j�ƺ+ ����ץfo-��P��6B���X�|$3p���K k�<��=q�x5�R��cl,

��z[���I=Vd�6�nҏ�Ywm�����+����R=��.'��qi{�@v{�C	�)#���Q�"p�����:�,[FWؼ������<\��:�e�~*@��²��^�s�5&V�/)0�Km{��>�%�R��\���o7�~�*ANaK�A��O=�g�><��c=bt٦s�N?��mW��z�^�?0~!۬Tm8��Œw�����w�N�z���w�~�۩~L�:>������{z����n�9����p��\��{r�;���7mq���RH{"*�w�>�88�>/-b���N0�v�oڲ�t�yҕx�d�@�3�B�G�m�\w{PXƓ�x��b>Z/�本�d�Of���i�`Ж5\��t���l�C�Y�������N���8hX���7n�~�ɩ���$���f)9�7k#� %h����������=��D�V;Fh�䌐d�����\�-)E!�z� l4�f%�#�iU-�0��	\@����q�XIa1_X2N���e���a���>��ҷ¡�s�d�,1_75c�fo����cf��������� �v��,���+� ��G�3,ʵ ���oq�Ϫm�b�:pX6���PO�â��A���>���A�˼r RSޔ
E?(8ش=>��]�,_�pOfi��Hsȁe?��$g(�v��l�!=}� �����i�����)��T@�{V"����m��[&dUŨ�v� 4v�/î�"���)���d�n�vvbeD�	b�l��R�R5���}Z�!��[u�2H�9Zۑ���Q��qؿ6�2|�� Ǳ�z��^U��.���"�ԙH�b��	#5z>[M0HTƦ��՝+,��`��Xn MXE���U�duQ�z�^���&�C|��75@�� �V�#�Oo������65:;�2�b�w�ۦڭ�i�;����z�W_7�G�U��A'�>ܛ���%��P^���;N,�E �������td�M[��?ji��S�p%�ĶY�^��s,�}���
h�����`�e(�h�L`"�mځ��r��	�X<�����r�|C̱,$>
x�g��C��}����7�˱z��Ԛގe���r�2G�iK�2|�x4�I0�6貼��7������#� �r�wE!Jk����h��h�`՛Ck�9��i9����c!`���"�M0ǲ��<)ǱQϵ<�0�P_z̱,�8�F�q({��Y>��s,K9Σ�rd�3g����	�X�r�G#�8a���MM0ǲ��<)��Q}�}��oh�B8����#�lf`2K���iK�e)�y$R���k��bO0{C̱,�8�Dʡ��̴Pׯ��s,�9�#�s�ʜ�:=��	�X�s�G"����L�;�lh�vY�q��#(���65��r��H��CI��}��W�&�cY�q��C̴}�k�5��r��H����1��wC̱,縏DΡ� R�c[���l	�,帏F�a�
��)Uo��,帏F���J˴�T��	�X�r�G#��D3}&�oh�9����H9h�qM�[�s,K9ޣ�r�D�-d��M0ǲ��=)��@$��T$9�	�X�r�G#�0��c�%ʷ��s,K9ޣ�r`""0QX�*w��s,K9ޣ�r���7T��6�-0ò��=��ˆ�-*\Uk�~zsd��'C%���[Vɤ]h�U/�]�㑻<��q�p��iK����=���q|���W���s,�]ޣ��l,���:�`�e��{4r����b���iUo�9��.���]0 H,�l��2�	�X���G#waUn2n��|� �+�\����lM+.�qne�Z̱,s��F���n�-���M0ǲ��?��Ƃq&c\TtY�iK����?���HX`U�5m���4�G#��D��y�<jM[�)�8���q��nk��-ߍz̱,���F��l�b�'�T�5��2��hd��-�jN}̱,��F��$�Y�(���`�e'x42;B���XnY�ӛ`�e9'x4rf�8�ǅe��z̱,��F΁�8�iۮ��M0ǲ�<9���X�@��&�c*�d���:�{r�u���V��qԛ`�Ai���R2E�x	\�V�vԛ��k���y	�!SD�!�A�����7�Yi��W�m�,V6Ui-0����@�pz���Yo�!�Ґ�O6$̠j����.vq8�'��܎�vy��&�SR�Ɇ��>��l��CrKCb֧��[cp��^�Wo�1y�1�O6&�H���`L囏ٟrL��-W���Ao�1��*�?����Z�7m	�|�0���D�v&XYj)6��ʗ�d(�9����
���c*�o��|X��ϳ75����}"�`H�%    L.|��M0�2g���;�"L��:�-0�2g����{m���}:�&S��۟��c�3X��L�z�����O��I�5A|羻�	�T�_>g��W�q�Q��۟��K)��<�|��M[�/�p���pt1[���+��޴�3+I��G�'��ݭ�a��)��$>�Mĳ.Y�=�}�\���+���� q0,�s�@���DP�k�)�Z��`�l��x�J��|_�Oq_Ӌg綫���4����5�p_GKB�9��)Z�S�]�,uX�e��-�e��!s��0P��4�7����>�p�sC`W�ϱ�MM0�T~H�b?�i�ɢWG��o�#	L����ޓh`w��0�k�nEzL��d�2NZ�2؞c2�e�����k��e7-����t����J,�[ZQ�>fޝ}�^�������`Y����K�p�v�5� ��XVe�X�@>�నFF{ؓ�HKO��rT���h�"(���3�ۥ�~��NV�d)�@���x#����3�ޢʞ����cY��x�U��B�j�B�ٶ��T=g���.�XLgz����;S8�V��cYRD�R���:�i����̡�D|�4O8�� 	���1�\��t.K����y%���ib���_��<>�-�zK�r%�{[����_�]��0�+c?>Y�8*!"��FX����J�B$���p�P5'�zW^hpi�Ċd��j6��Ua����_F�!��1ha"e8K~�˯ @&M��gs��o:��«����;_�
�h5���zn�?ݥB��qj�x6Wxg�b�������y��
=V�ܲ�X�P�>jz����|=*��x�>).bn1�۞��	�
+���Y�zV�O9+̢�>zD,���MpV��Y�O�/�4�� !����`��hk�>D����;��^$�����$��,l-)|���mL% �|��21���aڲ��:���Pᤛ-Op���늪�,=I!L�������M272`����[�d��͵;�R�J������|-d��;ċ;$�����2e'0,7�o�6�"���՞A���1���x1���8�?Q�b��
%Aiz�@�	x�u)F�,b�p�v�M�n�U���b�I��n^ݤ�7��+ $����\�'��]�۾�dA(�������&�0Q�0���v����I�n�kBA�i��0:ծ�$��v�М���Q?D��3�oK�9j���r��n��2.���eI0�BU]Ԟ�i���k��?��_8����3j7/2�|��s��z�:7�V��K�������:qts�9����K���Oy�n�mE���Pc�B,v?�0�F�&z�=j=��O�Ô�L��	�o`�u;����xit���;mE[�wk���:!&�]%XrX�3�cf�K���3�~��Cޱ�X���,�M��~q�'R�9�by��".V�A��HDE�+(�ʩ~D�����UD����y�g�:������D�i%���g'��p4^$
v X5,q���JU��6���7��Zw�"TJ�3�o��$nDX�&._�ڞ5�Y�|v�=c�_:�����{���}Z�'Q�(9�A�Haߥ�#�����[���g������b�5�K�i�ae�{"���8�=Y;m]��;���^��"���:ΰ"�G��l�xi���q����>��02�*Ч�����`XV8,�UfU�V<�������/���=�E��[��n��!�\�a�lj�A�ͿD7�xb�ק#S��u�r�/��V�&y�h	'(?� A1�Jˆ���?��{>�\���'����!�߱̀q^�=S�ati�D��_qp������\���l�BV?z��>���a��`0��,^d���dQ��מ�̾�
�(6
�p��T���-�^M��ρs����,��A�;��+� ������W�����I�p�u�b�s�J&�Tq:^N�XB�d���}�c�$3maU�Y&��9���3���&h�9��1���lh�-cR�����˂v�	,��mܳxW��l����i"���F�$}���C�����*��u�8�=��g��h�L��ޕh��Ht�z�f���(C���` "�w�{IH���l�,'W�C��T�q�.����j�풋�^B̷74�.�2-2���@����A��)U����Bu]�T��������š`i��C]|� z��GW�a�H�m˚�3*/�a2�BU�h��њ����}����s��{��������r9�m��֚`�K��%��}�U聠���IR\rZ1��TŊ���X��)�:O���#z=;��	�ʓ�N��Vo1��
�����$Y�tB:t "�7�+y"�s�DЀ�èb+��a�q��<\��$7�c��d��b�u�",�iE�u+������Ś��N'���ɤ��@��X�W�C�zp�j�d�_ʹʉ,fs�8,��>�����	=Պ y�eMW�,xB�Ly"g׼wf���t d�4\2)��a���K2��4>��N�e8��C -و��a����_���$-�/I��o}�����m���$y�d%���H �z,x�v���� ��&8%�H�9��5
�X���N@��U���]�T�7�"J���N.�h�I�kd���V�D���i:��Dꫦ�z7��If�+x%\-uZ�`fkw������$��m��aMǳ�|׶q�s�lIrr�?6�H��v�Mp$JvH�=i%KYq.7���̎���~�W�wTg�6a��T��,�%������`��?��k��j�ǃ��j�'˱�z�28>�� �����E��L罃�~$-<�;�Q���'�+�a�n���a'�B���0�ag��z<?ze��QK�>���5��ۃ��᳨o�����PU�~��z�t<|���2G�!�(��F,����v���=,��k���& ��M��O��"�o��荘�ʏ~�&���v���KIl!�}�lD���;%���<�hQ�23�������4:�T ���&����EFe��yx&��ㅒ�AxD���z��$%[\�����R��%�",53bt�L�m��?�&�N���d6�ɟϗ��#�������_�G��J~����^ź�ڲ�+�ƅ|C�`#L7l����CHI�X	:���eRқ��JVb�mj��@�nv���,��+I���K����j�<<���"*�K_0/V%Ԍ�dfEZ*c�f�m���f�L��{��ށ��4Tǳ���KS��������	[5Z[ ��r^o@��,��Bߴ�M��<��TN�6-WX��[X2�֓P����o�ˢ�_;kU�,�����8�[.�;�ձ�m��_��A��)v]k��&�1s���д�ؕ\��j�7��nn�!(_Dx��`n�01��h���0[{@/�cH�mꖘi��4FgV)�����q���f�g�������{�����NI"��9����W�V���n�������#l��a+:k���U�����~c8�%H��2Cn8�.����������+Pyg��=E�n�l������ȂD���x$EXh'R��wÂ!t�%'&��Yco2�t�9��];l=���)��������YZlV�h�c@����>���FօD*9�6����F��;��d��ǚ�1��MV�8N[C��<Nܺv��a��t�w�����������}Dru8 !�/�� �����
��)����v��ХJ�-�M
_�5�]�yop��Ftpv�A���u_���
t���s�?��|�#�b�o|1�6���K���Ӊ�A���|ܗ
�m&�p�!��7���[�.h'����W�����}uϴ:
�|�������{�s9����yd����kD�⻡Q�74���d�<`����v�ߦt��o]:gcH.�\ O�l�*C�b��J{��T�)?��8��x�n�-�%�L���T1��P���8�U@�NO�rJ��Y�_\��,�����0�P)��v�&���f��o/���� ]  �Ň�ɏ��,��6R�������STc%P������{ ����o�	r+p����C�y��&P&�>��lh�,'�sP`@��
������*C"��/H�մ�pA�%Q%���䑨����k��%����~m-I;��G���|5B��$���p�ʆ�JF�fk��v=D�$�[���u��"Yl��(��`c2�,(e����z�Pgr��r��&�ߢ�bY�D���.�CV����SQi�Z�]�^V��xf魕�!���gЏ�;�g�Q����l�d� �Yޙ�#_ û�i�f��,Ϫ����O;�<�#�J@j �8�'�K�6�������5~���r��,�� ����/�����e��d[����Ծc�=�gΔ�����:C����-�b�2B�JW��ل<�/a�$�0�7�dx{vF��kH���$�/�����r�>m;�yɵQl�CR2���I���]��qI�r�,fDVv*:�r�����)�;92C��->������,�aoh�#R2H������~��n���j�z�<���5��Jt\3+�ޖ���(���gtA(�^��<u%-��b5�X-2��?R��ܭ�a&��vv������h����N�'Z�{��r����#Ͳ��_Ƙ��+e���:�V�"�m��[L�J%O��*�B��G(��D��`��5��f<�O+@�ۂwÔH:A?h���y)�!���er�B�/eѠ�(�Sw�&Ie�{Q�i����n��v��`G�*R����Qhw j�c��v����5b�߭?WM��Uc�G|X{W��=Eܹ�p|Է�i(�v�'��po/����Oom~�Դ��xICѼ0}�U$K���du��6mz�J���{�����t�Rh��a`�L��5*l^��o8�u�7sn����a�⦷�8���4����o����W�����p�3nڷ��B]r�p���-��­m�Q%CB�*���p�K{7(��'B�W`��v^���E?����Wpv����_�<k/�S��8�� DI��	V�d凕C��4s�=�>��%$u�;�ׇw��)�oI�V&O�?��oU���bb6�a�֤a�~��c:��26�	
���|@�6���4�#t?���0���gg���O�zI?�h��_�Ϻ�K`���<��|mz5s�֬L�I����96�q�2�5^����p�ZJ��!	�k��1��g{a�AԌ��N`W�Ykj.�k�'��p�"��N�#sXwH|ث��A�ap6�$�ɿ�2:�� �!%$�?����,�������f�� �/H}�3˵7�wq�l;��S��gq����Ṵ�6����G���1�k���3����xT�е��,&�M[/9������,v��Io��߽�/���9���2�B�Jq�?G%1LN����h�~*�	ꭼ*�+K|*�g���1��N��z2�20�d�8KҴ���XX�fc��r�̾�BC氥ى6ެ��F�Ғz���U4�qT�~�H}`v1~��7�hFpR��(���@�JG�&���k��숩�̯�JǑ�B�/�2~�Ё�^�t1��g����,s�(m�,�zh@I�}
� ����>���#3���©h�ɂ>��t�0���j�����7A��4�[Gp�m���xk���Q}]aZV�Ά& �Rh6���&d��R�7����Iu���5و��x�A׆h:^`�ڭ��4N��-;���e��%gGg�Ѐ�f�[���kF�I�-	�2�f��f��eR\�3��'@^���;����.\��k9�t�J_d ����l_,Vpy�����dQ� �	�d$g���x"i3GM��XŠ�	�C���IH_e���b|��b�cp�*�L��RX;�O��)�L��ź��������=�]�$es7�z�>�8JB�����?j��A{Љ"�O��a�������߼����=
0iR0���`�e��*�C[�@&gq�y� 	oZ+9^h:�
�i�\�K+u{z�\�	H��? �k��i*v�{Y�ҋ��ǚ��0
D�+d
�&=V^��yupa�M�F�~��R^�)<��Zi��-��a��.�O�	��E`k͔?�4�ѡ�i��rS�i�%�%�e-�Ч�	��$�{����zV�~�	��E�w@��VR9y����N���c�)pj��=�:���~ΉgyƧ��'	���yʚN�/�6~3FZ�����O�d�p�\��ޜ����={c�����q�z<ײ���A6��(ٹ��Znq9��r��y���Sni�nh��m�z��#|�e�j�T�`a�h�:f���cZ�h��2�:�Bc��>�[P��SzI B̊8���f��2�g2A���A_�5r�Uyn��N;��6j����<zy�6�Q� h�&Z]���|�	�����i�F�a�}'x�F�ld
����`�K�P��#Lp��x\��#�Z*e��.�(<���y61|� #�m�D�̛u,ڷM+d��Ik�/vͷ�P>���a�lS,TɊ'ĺQ�.H�ú��j��v=�R�4�����oi,L2��D���Sz�m�%wF��L����8�e<���S	�#e�����ԎG#��artOh\�	< сT2�f(N���zT�9�J�A��R��kH�bcy��#/�� �Ò��"l�G:�>3��	��}��4�ᖃ'��	�d�:[����);��)��-H)o[�*���$����zv�I����+c�qx��A�y�������\Xqa6��뱖~�u�.۴�}�Z�Rg׼�����u�\��8��-,�Z�`Wc ������v�e�k7|��/u�ڂ�@GoO�6$�����%�0I�=�DaJ��6�M�Q��5*8št�W\�#��Rђ$���������3�/������������ԯ�Q0�γ�ҫ�q: CA-�?���\�SOp��09���h �{�0�E�5\��7+pZ�/����s�ߙI�W���a�}/���
,�AƵw�c
�����۬�==�����K%K��W9y�����Br`�M
�^�����!�r_�pΙozBX���	�F��G��0��NĬ�d>G=ɗ �����{�=��y��,�׹iyHG�f�h�Y���o?��P�8X	��	V�dc�U=��v;�����uj"��ӈ'�xW�j��d��&CGq���ik��p@����R�A��Bx�r��v�U���7����NG��W�� ��-�j1�A�����ۖ��i�qJfMؾ�:���Հ�m���j���U���)�;���Ƣ�F����Ymn���f.�/t:��*�æ�a_�-��%�ceE}6�o��p
�G��R�Ú4گ	��	�O2�ea�q�0R1"�;x�_�u�� \{�0����fq��-۳Ć&8K%�#��mfV�5�*�����vZ�D�,��e���γt�Z�{�X�n�sǯ�a�|Hu�$-���>�!�����T�,�����"[��_�n�T��n���ʴ��Q_H88ގ�MGp��Դ��Ńcח��.�F48��G��*ߡ*��%�F1a���8�B���m�J^<�����D�c!dy�,���Q��z���(+��D�����
�z�G:�qJ��^��[.��5((*�t�i��DZؿLE��E�['�x�A��]F��.��v��E��;Bu*,<�e�޽KDpl�7�)|�/��KM��%C+,:]K�X�(��&�HkгK��~���@f8�O^���j��h�(�x|�I�y�����뇌����U$ˉ�d_�gnn
�
[��u\@wG����&Xے�����=\��u� U�(d�}ѳh�����᫅��������Ƽ��      >   v  x������0���)�ky�c�F�Bj���^�4]!Q�u���}�N��m�WDh�HH�?��C&%f@��}��.�oߜG����y9$���;����C���(LrҒ�i)p�`�ӊ���-�p\2�m����$X���e[�C�=U�ʗ�ah ��Nq&
��k_o��v=JXJ'�a��A��Ȋ���囲�f�o�Y>[}Y,�V�z���*���4C4I>m����c4�W_�,7�?������&_�>_����^Ц0:�翎�7�c�H�S�I"~K��曜B��,b�]������J%y�!��!������!�������B��BT+��#!��$ 8C�IC�"����!����H[{�5��"	(��6���ςq L����� �8��h�ĝ��:�Lw\����~`۳���B�т��r�-��_)�`GY ZƂ�[Z��¸sN
ԑ��yTw@��kx�[yT���~Hy���˪9���p���^$�59����t
C�dh�Fi���[��Aa�<hۓ6�$�{�9�A'�S���$��%'yuʻ��Xy_~�{�?	����I�ys���[��P�[�YՔ�׻]�0�:���>��d�f!�3      :   =   x�3�46��4�t-V(�KT((*MMJ�A����X� �M��̬L��Mq�s��qqq ��,      <   A   x�3�424�4�B##c]R04�21�22�360�%�e�ib���� ����P���0W� ]4�      @   �   x�}��m1EϦ�4|06���:�Y�a�	#�����̡�cb��s�K��%�6��d�{a�!:N�s�e���R�J�EL���2c��q���TL��W�i�w�J�*߼�lm/ˊd��8�g���8��Dk��,���2��.�/ɂ�������z^1�r�}��I�A�S%y�;N�'Wl��8�Y7�F�_k�<;N�w�t����2�-'����:�����8�0�W��8      ,   d   x�3�tL.)M�ɬJL��4C###]C#]#sK+CC+c#=3KCs<R\ƜΉ�I�x�11�30433�'�e��\���+S=K3KKSK<R\1z\\\ ׭,Q      6   m   x�3�t�/*J��4C###]C �T04�2��2��361�%�e���XR�XP�� c3=cK\�\Ɯ��y��9@�1~ Th�k`�k`�`hheh`ej�gih�K�+F��� �p'�      0   �   x�}�=n1�k�s������A�4^�M@c���Z��r1XD�F
h�'��{������E�R��3uԗ'�c-��?|ց6��"�嬶�1���"�稭j�w�Ҋ�o�J�J�|-�t��	�=!�=ƚ���?3D��&(��҉5þ�M�a&�LiZ�7�N���T�Ft�>70>z[����}dI/^����wⴣß%��+��7�%ߔ��'�qK      2   �   x�}��
�0���S�Vڴ�fϞ=8�^ƚCq�e[}~E��0	����źa�9�W��)Z S��B��i�!���#P"V
+� ��)-�-�#;�\h\�ʟ��ԕT�� [���ZԻݖ�5ۗ<����u�^��x�/�ߢ�F(��tn�!�L��W�dHB��+��kr?������-�mD������g�9�E�d�      4   Z   x�3�t�)I�4C###]C#]#s+C+SK=cC#\�\F��y%�E��)�8�0�2��36�0&�e�锘�S������%.q�=... ��%f      .   D   x�3��L�N-�4C###]C �T04�25�21�344�%�e�\����3+#=##\�\1z\\\ R0�      }      x������ � �            x������ � �      y      x������ � �      {      x������ � �      �   y   x�3�I-.�4�4202�54�5�P0��22�20�305�)n�i�e�����l�k`�k`�`h Rdj�gna�S�٘ӱ '3919���<��T���܂��bL�,��M�L�0���������� y*n      �   �  x�}�M�1���)|,�l�v#F�I��(�2�qF��F��[e�\,e�20`Ԩ��>�]U�;�}-������o��� ��Lf�����5�x��<�Ŝ�9?.R�1F��m����D����wc�c��K�ɞ
e�:�z}ن6Ci��n���5��s"~M���i�1K����4���S9�^��:���c �֑aѷ�i�?�:���?K�.��Nhj{����>�_�x2 -�ɟa�)��?�$�r\S.Ց�9��J����ޓ9y
	}}8ὓX�Y#ͽ'����aw���?�S��#L��%�}L7�v{ta������k4�.r�桄U��Վ�j��)��>�ؚrv�l��K���m�R��-^���[�A[�vU�6�,>��M�8��$uX{*�h��cS,�~i��y����I�$г>}/W�F۷g�țP�xyʧ��qCMG���Ǹ�?oA���}�뀽����l6�-g�      �   �   x�uα� ���x�� �;��:�uqu1���HC��/�������~9��l�{^�,9mQcl���$
��J]ʵ����g0��\�7��6?�#�@I�q@/>
F��
I(k�υb8��Z��Ж��X<�R�7�l�RoG.7�      �   c  x�}�Mn�0���)t�៨]�A�H�fۍj�� G4()@{�.�!댓 �#
0�x�|��(.�)=�S����i�� �
q�EW4����
�^]����L�8倫��3�7P�:@p��D,Ǭ8L9U]�.�C�����Hu�KD��tHy�/�U�_�j�m �sE��k����}܆ �_ѩ>��!G���v�wmw�F�ӛP�	�hc?Nqؽ���n��(,�L����#���AL-�^������"�:�+����X3��B[֙bD-n1�s~J� F5�I�����:��?]�[�@�hVt�8�E��d��8�U�<]���ޮ�L�D��)�XݥLA��ۼD3N���:��3�]����Q�:���=�]�q�~U�78�$䥔���5��:!���>�~HOm����@����z�#W����.���>�p{�7�pT����������F�K�]��xT���2�<�~��'c`��/�B%(�7�jO�:3vl�̨����3�*��p�Шc��^�����S�_<��!�r��i�K�u�5�/1W
���3���0�9�G\sɡ՜BP��3�z�_�1>�MK]KЮ���l6�|�|�      �   �   x�u���0D��+���]�����)�����O��B����p��x��$}.)�H��h�D!p�Ev k��ӝFQI�	�������rDR���7������&G���I����ϭ��pX����������sm�}WI�      �   3   x�3�4�I-.RFFF��F�
�V��VƦzf�8�9�b���� ʍ�      �   C   x�3�(*MMJ�t-.ITH-V(�KT(�r��X(X[�����6�4����� ��      �   X  x�}�Mn� ���\ ����Y��UW�vC�WĎ�^�G��:v�4?"�'ާ��F�~����2_it�����D����m��
E��3������qt��O�ppc�v�����L\ye���
�57�ff�N�Nώ
�z����!�M�/�c�n5��]c�^[�Yi���� l�fˮļە>�)P�N���G�4�1�b[,�B���uB5�u���C��ţ����N,sיG�z���Շ���e���n$�/���j���E��ۆ�D�)d���@��
i�Z��>��j��4��{�^��5e}��e��b"r�>9~�!lZ]��Uo���?ǉ��      �      x��[�rɕ]g}~��~pe�Zݶ,�5-GO�7�*�d�=�n>��^����l�csnUd�Ǒ(Q$��E���8�f�(��j��:,���}Y������e�c]��_v��Z�}j�b��-�W�k�&y�eM�mW��Ͷ��zs�ys���a�I.U�e+�B��/tXZ��:2�2&���ݨ�T���A۟��N�Lo��^�����ſL���F�m[��"�1X�]�T	�t��Y��y�4{���Kt��ȐYr��U]�n;�{/��涮��x�e��:.���[<�6x�+V����ؖ�;<y'[�j;��^ڮK�^�s^z��.����]
+�
O�ą�K�'+�_~��T#�7�����Ƣ�7͂)C�#sѺ�y�z�t�c�m�~�t��a;Tb�z��#d+����ź��{�D�Â;�H0C<�{ل�X��j�]�Z�:�l?�؎��x�q]"3��ʕh�p'<���,�"�lBv��|;�:e��P�B�7��2r��8�{ي�X�؛-�w�m��v���Zl�l�mv]huH��9�6ik�7�T�X�?��K�E�m��=}���Һq�{u'h�j�a��ͪl?�u]|�7�j�Y����k�������k�Lm�]m��w�(�?ϓ�H@�Vj�1��K��:_6� ט���	�/Q �����&����+&+�[���Naa:�V+��I�,��/��y���BzlȒs)�z>$���0�rP��){��J�j}�
�(��6�8��=w��W~^E�R٠,Ƞ��j����Q�sW��,4�%.���rdH,5YH�2)<�%�Pc{߯n�^�c�	�������w�̀"Q�뼊pb�w��T���[_
�(�eŮ�4�,#�\#���X�Ɇ�Ɨ�؋5����%�R퇺ZՌ���a1:[��m�u�!~���Vi:��b�"G���a��g����!���c=�<$�\���~���³2��#�k�ǡ~�0�:�U�f�"[�F�8� ,�����$��l��+U��#Cni������$�8�~�Z/>ƻRo���#"b�(���APDd�*�6��P�<��P���r�{�NM��)k�92$��O&�����k�������R�����o�/��������W���#�m�< �\ۘtn�F��Q����v���RT6���ai�0�K�C&ƿ_W�+�k�c��0��yjy*�՝�mrE�$�*�|a���T
8�\�|n#&�t\ٯVI����ݮ���·�����M^|����Fꎣ���a����U���P�lr�c��)g8<kGg�!D�'|M�^v�Q����vq}��iG�h�jj�.�K��F�Ԛ8�*�s b�91Ț��Ȉ5�SNUK@�إ�k}tH)?{�^�	�1I5��wu����V��p�X�5*���P��@���ӕ6Z�ڮ�Y˃𜭆������y��Z�z�'�a������!0�}]{��k��iG�����:PY���� ��/;<�ſ��M6HH H�T���?¸�6�Z�P�S�<��.k睅8�yh�G����)8*_ޙ�Xc5{�SBz���D��#eJ���i�c�nKN(ռ�6�X[�>iQ$��v�rV�֨�R:��4`�/̄n�x�OR�����ŏ�E@�{2�j�Yo7L�Z�ѩ��A�,B'׺̽p<���lN2鉳i{a W�G�D����e&���۾^"��<9��6�l�����	��nc�@�z�x+\(��"v���Ig�i�Nqa��!��`'���/�q�k$�V�#�Bq����/���fN$�d��K���b?`m���.V?o>���p�q��+}4D�7�4Fu'2Dx��xM\�ժ#�Y�����"��'f��x��H�Xe۔U��:�l��朱~A���D �bZ�A婮�$� ^M1�!b��nG<u;90F��̲�f��'��Cx��U�!�8˟�~��H�p��`��!I%������ �H�o�Y�_v���m2�ej��%>�+m	��4)�gW:v��׫/DX�\��0�h�Y�nO���	�)w��n��:���~�Y4�r:�	�/ic���1��.G�
r��~��m�_G�	�C�eP��š1�>(��I㏏D���H]3d�W�2T���������'w���UŢ�d��г12w ZNT�������1đ��J�#C�br����{�j�?^�;��O ���W��	&R�oJ�.����:��BN&�-�6d�t�����*RW�	8��4�5jl%�h-���CI`�x"LR��F�ȿ�~�o��cw����hO� ��Ʒ\W����֫[��ZM4��b�g�aG�������MN®L��A�	⺗k ��n��;���A� �]�z�?�|)R���.���..y[S���+#~�7�3*#B�.��!4DHk
����5�5���S�Ö 1�x����O��a��"$�`��R�����[cjb�9���"*bf�SM�N@E�i�F�»݈�AW1�l��,VU�̾UQ�=iX|�_
���P�.�Yg�oi�:����h��9(t���{��)�����ݔ���^|��e�I�@�Z%j�����U��E���u�O�d�,�PMzf���%'�)=ѧ:6(��!�K��D���l�͹�A��6�#J������U+�i�׍ߙ�(�>���k�A�	�8�5Z��j}�x���:��x}�e+^RB�%�aG3L.�%1ך�O^���y���`�+g�I��wg�ܻ=���ݝ�,W]�B���*:��v*�'[;�׭�X��e�Y|�p��6o�8�zY�h�d$���XkՊ$#���d��k ���q��0��������7�?��?�.ぁ�'_��:����)�J��b8���u����/l�i�vV�~�!<��f�7<�<��r�����~ �B��l�Et��� B��[��`�
9,
%�ۼ���Y:SA��4D��i3f�'�(�(�ެ�]Y�G؂4P#���M,��>��:�m�<����&�#�u��(�.O箘H��$W�x�Ds�xV̧!�ě�;ZjO����ث���nM��_6����Hkðap&�-P��T��VPT�e�V9S
PQ<��`���Kn��!��'[�9��I�Q����n��}B��msY'|�����jϥ�gŜ�̪x$4�,�^r)͑T�Cwq�wjH�с�a��%i-�՛!ߩ�κ�r��l3R+����'�*��V(�'��U��$��;2�X����r���?6y�d掞z�k ,b��P3=�d,�iQ�ک��-�'�"r0Zk7Sx0g0�8��=��I�29l�~W�!���<�Cm�ۺ����1l��q&jc!%�D6�I��M��6F�Z��Zl�Uv��������xI�͗��e��!d�p���_#LB�F���F��߷q��B=̛5K�� �Gd:]�H`\Dq����!��|y,e>Y��F��Nhud[��Q�U���a�j�g?� ���q~��Ue*9Y��3���Mñd1H\2K"X)U6�{�,���:RE@w����pΡ�0o�a��E� H�7wtU�P��H�v�z�b��r(���nM�+m �h��"�NDv{;�z�<uN��N>���ޑ!�4z��{�/[3K5p�	��Z#	 j}�����vq��s����,uk]G��\i}R`�G\|Ch����Ő[���������x��5Ȇ����T3PyW#��R��D��PY��
"��oM�իX��jf��u|�S�=EY�S���3�;U� ��&G���kT���B�H��òs�U[T�����NB�8xJ.Pߑ�n�Ig��t�~�G������5�p�I����u�w����5�rΔ�Է��mGd$%�4^�I�
j=d���i��
%�,����Ƣ g�c�j�KuPy
*Nb\��M���~�V�CK�Ѣ�<�6�>��n��ј.����E�����C��O�>�!.�������4Ҳo����73|Z����}� ����-y�l��;�_�ʥOgw�-�p   �q�<mQѐ�Gr:�A=K5��on�6j]����v�|�9B��t��ۊZ�:��X:�|�cuC�g-_�(���D4q;�
g�'��(�(�~���P�C�?��f�(��*t'A��k�xr3�@�O˱xkk���74�,R!�RqD�R!Q��l*ѳʗ-��E��@WA��7��@&^_��|�6�%�i�Z:���E� ��)��=���粉�b��I1�F�2���<�MLR���gp��E�Y+�ԑxفS�����1(w����´`�M ��tlH�=x��\Z@a��hiO7	cF��;���-�1#�V(��*�6�jd f���������:�-2� ]rK:\�L���_a�2SU:$������K��O5
%Y� e
�	E)��`�(Y�G�Y���焈�����ud��${j4�<�F�FS;n��[$��R��]�ܲ"�����h����h�.3�-Ф3n�!Q������0a����\���N��Y�AH��nu���o����:�5�1:O6A��������ʨؗ4N9eP:�ڧ䔆@��>��u�l�,�(��<t���x����w�I/L*��� ��=u��h+�&����jx�ۅ�R?K�b<�J&f�'��(�(�~�_�: ��w0,����k#snJ�� �Jc��5t�'#4H^
]Љ���&����\�� �G�����A���X��\� ]��:á3��J�Ĥk�8o�i:���k(�ۘ��؍W�ϲ�T#���x��QXL�o;��T���5���� �����S5dM���԰��w	u#X̓�H��?���` �i������d�c�'�-<H6��5��ݖ����������a��W ���IV��7O��̅]�Ig|h���Z�,��qtk���'����ب�x�_���l�&���i�tK��4h�LB�h��(���]b�Ӥ3��x��j��+z<���혃��3�5n�n��n��;ݴe��r	�1E0`]Uv�cgRL-7���KW�����tO���*Kmh5����q)'���R�����u��G7�4���&�1�x0�/8]�#�2�_,X8J6�7�9g� P!}h.��%j��M�Q�ɛ�$�`�o�z�ȟ�*K �(ު�PS*𯷨)�}^4p	�:ӝ,�n��6�=�`f�8���kW�y�^��#4A-������v_ow�?���;EΩ��C���V*Å��p �KČy��k�S>�B
�!�ɩ%�H�	�rl��l���8�      D   ;   x�3�t��L�+IU�Ey����F h`d�k`�k`�`hje`aeh�gla�K�+F��� �4�      F   �   x���]j�0�g��@�>,��!z���,+��I��g���]F��l��_`2�0]�K�~@�φ׃,R��@.�$q������Ӂ49*��1���+�eC���!F��S<-�/籟򜿖?qy�+>�\"���|#����VtĻ�����0o{T<�y-�'����y���4|��/�!)C�۸�w���k=f��N�*�r{o�Ѽ7�
u)��O�����k�/�
�[      $   �   x�u���0�Rn ��˱jI�u��_�0�׀�iRH��C��l�r)Ӟ��|�w�f��3�g,/�%�h�����m9���g�d�JD�r>���#�7h�K�[Γ�x�+�y��3��ՙ��'@z      "   j   x�u��	1�Rn�F+�|�j���H!����a!_�{��ݲ�*Q��:q��Ok��X��xs��V1r���p}�	s�׉+���?��x�zU}��+'      &     x�u�[��0E��*�� .�����cpZU3� ��N�&�-(���(?P�E��'��e�r�_b�vv��x��Q��Ԍ��c��*��l�2N����˵Sp�ХQ��4���zG7�)�-�}�	�8�-{*��J�i^s����3N�E���}��6�n'`�O��]�ex�	�m�T�l��X'Z��ޗ
O����Г�ѥl�f0���l-��G��P1��*q>���r����<�\�~�/�����}w)�y�d_N[���G��������Ӌ����[      �   1   x�3�4C###]CR0��22�24�3�D76"=Ks��=... ox      �   /   x�3�4BN##c]C]KK+C+C3=Ss#��@]\1z\\\ qh       *   �   x�u���@ �Kn��/���:�G����50��!��ٹ�6:�����oKò�z:�n�hq뉙�� CVn��q�|n�%�(Plo��Ivj�բ�������\g�����u�Η����k_r�K����}šϥ�-e�����@ xQ�T�      �   �  x�}�ۍ�0�o��i ���˵l�u,/�`�25I�������G�ȋ�%���*S-}����+�>k�Skc���!��5�J��V�[3k��%���z���[�ȫ�nW����Z�燜#��ZI��s�3tM���m���������sp�3^5�%��#�Bl��\�ϔi��'7p-)�>ܱ��kpNy������������啬Tm�����*���}>��S��q���3�:������ϝK	�N�.ԗ����s�u�Q&���>�;�[��ͫT��spOޫ|����9�As���q���5z_�\�q���>o�%�B��;�q��?������|^w���ſr��y�^�;��пr�x�3�>)c�4���9��ʡL��~��V�?���|<Y��\��'�W����ϩ�Ws}n_9x��y���>��?t��_�i�      �   O   x�u���0C�3L��A�d��?G��-߾�\�_ ���X��a��}�/�i��~�IlY�M��)Il�i?�5U� Dm*=      �   J   x�u��	�0��]�AR܄x��?GS�7�:)�.�2�a��ߍ�ɰ���
���:���GOK���� �     