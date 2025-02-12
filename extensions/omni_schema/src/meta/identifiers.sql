/*
This code is partially based on meta from the Aquameta project (https://github.com/aquameta/meta),
licensed under the terms of BSD-2 Clause License. It started off as an integration but became a
significant re-working.

BSD 2-Clause License

Copyright (c) 2019, Eric Hanson
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
create type cast_id as (source_type_schema_name name,source_type_name name,target_type_schema_name name,target_type_name name);
create function cast_id(source_type_schema_name name,source_type_name name,target_type_schema_name name,target_type_name name) returns cast_id as $_$ select row(source_type_schema_name,source_type_name,target_type_schema_name,target_type_name)::cast_id $_$ immutable language sql;
create type column_id as (schema_name name,relation_name name,name name);
create function column_id(schema_name name,relation_name name,name name) returns column_id as $_$ select row(schema_name,relation_name,name)::column_id $_$ immutable language sql;
create type constraint_id as (schema_name name,relation_name name,name name);
create function constraint_id(schema_name name,relation_name name,name name) returns constraint_id as $_$ select row(schema_name,relation_name,name)::constraint_id $_$ immutable language sql;
create type constraint_check_id as (schema_name name,table_name name,name name,column_names name);
create function constraint_check_id(schema_name name,table_name name,name name,column_names name) returns constraint_check_id as $_$ select row(schema_name,table_name,name,column_names)::constraint_check_id $_$ immutable language sql;
create type constraint_unique_id as (schema_name name,table_name name,name name,column_names name);
create function constraint_unique_id(schema_name name,table_name name,name name,column_names name) returns constraint_unique_id as $_$ select row(schema_name,table_name,name,column_names)::constraint_unique_id $_$ immutable language sql;
create type extension_id as (name name);
create function extension_id(name name) returns extension_id as $_$ select row(name)::extension_id $_$ immutable language sql;
create type field_id as (schema_name name,relation_name name,pk_column_names name[],pk_values text[],column_name name);
create function field_id(schema_name name,relation_name name,pk_column_names name[],pk_values text[],column_name name) returns field_id as $_$ select row(schema_name,relation_name,pk_column_names,pk_values,column_name)::field_id $_$ immutable language sql;
create type foreign_column_id as (schema_name name,name name);
create function foreign_column_id(schema_name name,name name) returns foreign_column_id as $_$ select row(schema_name,name)::foreign_column_id $_$ immutable language sql;
create type foreign_data_wrapper_id as (name name);
create function foreign_data_wrapper_id(name name) returns foreign_data_wrapper_id as $_$ select row(name)::foreign_data_wrapper_id $_$ immutable language sql;
create type foreign_key_id as (schema_name name,relation_name name,name name);
create function foreign_key_id(schema_name name,relation_name name,name name) returns foreign_key_id as $_$ select row(schema_name,relation_name,name)::foreign_key_id $_$ immutable language sql;
create type foreign_server_id as (name name);
create function foreign_server_id(name name) returns foreign_server_id as $_$ select row(name)::foreign_server_id $_$ immutable language sql;
create type foreign_table_id as (schema_name name,name name);
create function foreign_table_id(schema_name name,name name) returns foreign_table_id as $_$ select row(schema_name,name)::foreign_table_id $_$ immutable language sql;
create type function_id as (schema_name name,name name,parameters name[]);
create function function_id(schema_name name,name name,parameters name[]) returns function_id as $_$ select row(schema_name,name,parameters)::function_id $_$ immutable language sql;
create type procedure_id as (schema_name name,name name,parameters name[]);
create function procedure_id(schema_name name,name name,parameters name[]) returns procedure_id as $_$ select row(schema_name,name,parameters)::procedure_id $_$ immutable language sql;
create type operator_id as (schema_name name,name name,left_arg_type_schema_name name,left_arg_type_name name,right_arg_type_schema_name name,right_arg_type_name name);
create function operator_id(schema_name name,name name,left_arg_type_schema_name name,left_arg_type_name name,right_arg_type_schema_name name,right_arg_type_name name) returns operator_id as $_$ select row(schema_name,name,left_arg_type_schema_name,left_arg_type_name,right_arg_type_schema_name,right_arg_type_name)::operator_id $_$ immutable language sql;
create type policy_id as (schema_name name,relation_name name,name name);
create function policy_id(schema_name name,relation_name name,name name) returns policy_id as $_$ select row(schema_name,relation_name,name)::policy_id $_$ immutable language sql;
create type relation_id as (schema_name name,name name);
create function relation_id(schema_name name,name name) returns relation_id as $_$ select row(schema_name,name)::relation_id $_$ immutable language sql;
create type role_id as (name name);
create function role_id(name name) returns role_id as $_$ select row(name)::role_id $_$ immutable language sql;
create type role_setting_id as (role_name name, database_name name, setting_name name);
create function role_setting_id(role_name name, database_name name, setting_name name) returns role_setting_id as $_$ select row(role_name,database_name,setting_name)::role_setting_id $_$ immutable language sql;
create type row_id as (schema_name name,relation_name name,pk_column_names name[],pk_values text[]);
create function row_id(schema_name name,relation_name name,pk_column_names name[],pk_values text[]) returns row_id as $_$ select row(schema_name,relation_name,pk_column_names,pk_values)::row_id $_$ immutable language sql;
create type schema_id as (name name);
create function schema_id(name name) returns schema_id as $_$ select row(name)::schema_id $_$ immutable language sql;
create type sequence_id as (schema_name name,name name);
create function sequence_id(schema_name name,name name) returns sequence_id as $_$ select row(schema_name,name)::sequence_id $_$ immutable language sql;
create type table_id as (schema_name name,name name);
create function table_id(schema_name name,name name) returns table_id as $_$ select row(schema_name,name)::table_id $_$ immutable language sql;
create type table_privilege_id as (schema_name name,relation_name name,role name,type name);
create function table_privilege_id(schema_name name,relation_name name,role name,type name) returns table_privilege_id as $_$ select row(schema_name,relation_name,role,type)::table_privilege_id $_$ immutable language sql;
create type trigger_id as (schema_name name,relation_name name,name name);
create function trigger_id(schema_name name,relation_name name,name name) returns trigger_id as $_$ select row(schema_name,relation_name,name)::trigger_id $_$ immutable language sql;
create type type_id as (schema_name name,name name);
create function type_id(schema_name name,name name) returns type_id as $_$ select row(schema_name,name)::type_id $_$ immutable language sql;
create type view_id as (schema_name name,name name);
create function view_id(schema_name name,name name) returns view_id as $_$ select row(schema_name,name)::view_id $_$ immutable language sql;
create type index_id as
(
    schema_name name,
    name        name
);
create function index_id(schema_name name, name name) returns index_id as
$_$
select row (schema_name,name)::index_id
$_$ immutable language sql;
create function column_id_to_schema_id(column_id column_id) returns schema_id as $_$select schema_id((column_id).schema_name) $_$ immutable language sql;
create cast (column_id as schema_id) with function column_id_to_schema_id(column_id) as assignment;
create function constraint_id_to_schema_id(constraint_id constraint_id) returns schema_id as $_$select schema_id((constraint_id).schema_name) $_$ immutable language sql;
create cast (constraint_id as schema_id) with function constraint_id_to_schema_id(constraint_id) as assignment;
create function constraint_check_id_to_schema_id(constraint_check_id constraint_check_id) returns schema_id as $_$select schema_id((constraint_check_id).schema_name) $_$ immutable language sql;
create cast (constraint_check_id as schema_id) with function constraint_check_id_to_schema_id(constraint_check_id) as assignment;
create function constraint_unique_id_to_schema_id(constraint_unique_id constraint_unique_id) returns schema_id as $_$select schema_id((constraint_unique_id).schema_name) $_$ immutable language sql;
create cast (constraint_unique_id as schema_id) with function constraint_unique_id_to_schema_id(constraint_unique_id) as assignment;
create function field_id_to_schema_id(field_id field_id) returns schema_id as $_$select schema_id((field_id).schema_name) $_$ immutable language sql;
create cast (field_id as schema_id) with function field_id_to_schema_id(field_id) as assignment;
create function foreign_column_id_to_schema_id(foreign_column_id foreign_column_id) returns schema_id as $_$select schema_id((foreign_column_id).schema_name) $_$ immutable language sql;
create cast (foreign_column_id as schema_id) with function foreign_column_id_to_schema_id(foreign_column_id) as assignment;
create function foreign_key_id_to_schema_id(foreign_key_id foreign_key_id) returns schema_id as $_$select schema_id((foreign_key_id).schema_name) $_$ immutable language sql;
create cast (foreign_key_id as schema_id) with function foreign_key_id_to_schema_id(foreign_key_id) as assignment;
create function foreign_table_id_to_schema_id(foreign_table_id foreign_table_id) returns schema_id as $_$select schema_id((foreign_table_id).schema_name) $_$ immutable language sql;
create cast (foreign_table_id as schema_id) with function foreign_table_id_to_schema_id(foreign_table_id) as assignment;
create function function_id_to_schema_id(function_id function_id) returns schema_id as $_$select schema_id((function_id).schema_name) $_$ immutable language sql;
create cast (function_id as schema_id) with function function_id_to_schema_id(function_id) as assignment;
create function procedure_id_to_schema_id(procedure_id procedure_id) returns schema_id as $_$select schema_id((procedure_id).schema_name) $_$ immutable language sql;
create cast (procedure_id as schema_id) with function procedure_id_to_schema_id(procedure_id) as assignment;
create function operator_id_to_schema_id(operator_id operator_id) returns schema_id as $_$select schema_id((operator_id).schema_name) $_$ immutable language sql;
create cast (operator_id as schema_id) with function operator_id_to_schema_id(operator_id) as assignment;
create function policy_id_to_schema_id(policy_id policy_id) returns schema_id as $_$select schema_id((policy_id).schema_name) $_$ immutable language sql;
create cast (policy_id as schema_id) with function policy_id_to_schema_id(policy_id) as assignment;
create function relation_id_to_schema_id(relation_id relation_id) returns schema_id as $_$select schema_id((relation_id).schema_name) $_$ immutable language sql;
create cast (relation_id as schema_id) with function relation_id_to_schema_id(relation_id) as assignment;
create function row_id_to_schema_id(row_id row_id) returns schema_id as $_$select schema_id((row_id).schema_name) $_$ immutable language sql;
create cast (row_id as schema_id) with function row_id_to_schema_id(row_id) as assignment;
create function sequence_id_to_schema_id(sequence_id sequence_id) returns schema_id as $_$select schema_id((sequence_id).schema_name) $_$ immutable language sql;
create cast (sequence_id as schema_id) with function sequence_id_to_schema_id(sequence_id) as assignment;
create function table_id_to_schema_id(table_id table_id) returns schema_id as $_$select schema_id((table_id).schema_name) $_$ immutable language sql;
create cast (table_id as schema_id) with function table_id_to_schema_id(table_id) as assignment;
create function table_privilege_id_to_schema_id(table_privilege_id table_privilege_id) returns schema_id as $_$select schema_id((table_privilege_id).schema_name) $_$ immutable language sql;
create cast (table_privilege_id as schema_id) with function table_privilege_id_to_schema_id(table_privilege_id) as assignment;
create function trigger_id_to_schema_id(trigger_id trigger_id) returns schema_id as $_$select schema_id((trigger_id).schema_name) $_$ immutable language sql;
create cast (trigger_id as schema_id) with function trigger_id_to_schema_id(trigger_id) as assignment;
create function type_id_to_schema_id(type_id type_id) returns schema_id as $_$select schema_id((type_id).schema_name) $_$ immutable language sql;
create cast (type_id as schema_id) with function type_id_to_schema_id(type_id) as assignment;
create function view_id_to_schema_id(view_id view_id) returns schema_id as $_$select schema_id((view_id).schema_name) $_$ immutable language sql;
create cast (view_id as schema_id) with function view_id_to_schema_id(view_id) as assignment;
create function column_id_to_relation_id(column_id column_id) returns relation_id as $_$select relation_id((column_id).schema_name, (column_id).relation_name) $_$ immutable language sql;
create cast (column_id as relation_id) with function column_id_to_relation_id(column_id) as assignment;
create function constraint_id_to_relation_id(constraint_id constraint_id) returns relation_id as $_$select relation_id((constraint_id).schema_name, (constraint_id).relation_name) $_$ immutable language sql;
create cast (constraint_id as relation_id) with function constraint_id_to_relation_id(constraint_id) as assignment;
create function field_id_to_relation_id(field_id field_id) returns relation_id as $_$select relation_id((field_id).schema_name, (field_id).relation_name) $_$ immutable language sql;
create cast (field_id as relation_id) with function field_id_to_relation_id(field_id) as assignment;
create function foreign_key_id_to_relation_id(foreign_key_id foreign_key_id) returns relation_id as $_$select relation_id((foreign_key_id).schema_name, (foreign_key_id).relation_name) $_$ immutable language sql;
create cast (foreign_key_id as relation_id) with function foreign_key_id_to_relation_id(foreign_key_id) as assignment;
create function policy_id_to_relation_id(policy_id policy_id) returns relation_id as $_$select relation_id((policy_id).schema_name, (policy_id).relation_name) $_$ immutable language sql;
create cast (policy_id as relation_id) with function policy_id_to_relation_id(policy_id) as assignment;
create function row_id_to_relation_id(row_id row_id) returns relation_id as $_$select relation_id((row_id).schema_name, (row_id).relation_name) $_$ immutable language sql;
create cast (row_id as relation_id) with function row_id_to_relation_id(row_id) as assignment;
create function table_privilege_id_to_relation_id(table_privilege_id table_privilege_id) returns relation_id as $_$select relation_id((table_privilege_id).schema_name, (table_privilege_id).relation_name) $_$ immutable language sql;
create cast (table_privilege_id as relation_id) with function table_privilege_id_to_relation_id(table_privilege_id) as assignment;
create function trigger_id_to_relation_id(trigger_id trigger_id) returns relation_id as $_$select relation_id((trigger_id).schema_name, (trigger_id).relation_name) $_$ immutable language sql;
create cast (trigger_id as relation_id) with function trigger_id_to_relation_id(trigger_id) as assignment;
create function field_id_to_column_id(field_id field_id) returns column_id as $_$select column_id((field_id).schema_name, (field_id).relation_name, (field_id).column_name) $_$ immutable language sql;
create cast (field_id as column_id) with function field_id_to_column_id(field_id) as assignment;

perform omni_types.sum_type('object_id', variadic array_agg(t.oid::regtype))
from pg_type t
    inner join pg_namespace ns on ns.oid = t.typnamespace and ns.nspname = current_schema
where t.typname like '%_id';
