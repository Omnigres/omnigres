create function create_meta_diff(
    baseline regnamespace,
    changed regnamespace,
    schema regnamespace
) returns void
    language plpgsql
as
$create_meta_diff$
declare
    types text[] :=
        array[
--## for view in meta_views
            '/*{{ view }}*/'
--## if not loop.is_last
            ,
--## endif
--## endfor
            ];
    type  text;
begin
    perform set_config('search_path', schema::text || ',' || changed::text, true);

    foreach type in array types
        loop
            execute format($sql$
    create or replace view added_%3$s as select b.* from %2$I.%3$I b
        natural left outer join %1$I.%3$I a
        where a is not distinct from null
    $sql$, baseline, changed, type);

            execute format($sql$
    create or replace view removed_%3$s as select b.* from %1$I.%3$I b
        natural left outer join %2$I.%3$I a
        where a is not distinct from null
    $sql$, baseline, changed, type);

        end loop;

    return;
end;
$create_meta_diff$;