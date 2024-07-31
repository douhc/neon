# 测试脚本
```bash
# 登录
psql -U cloud_admin  -W -d postgres -h 127.0.0.1 -p55433
```

```sql
create database mydb;
\c mydb
# 创建扩展
CREATE EXTENSION postgis;

-- 测试用例出处： https://liuguangxuan.org/index.php/archives/33/
create table airline(
    no serial,
    ph varchar(10),
    gd numeric,
    hx numeric,
    sd numeric,
    jwd geometry(point,4326),
    sj timestamp,
    PRIMARY KEY (no)
);


-- # 采用系统的random()函数生成经纬度
-- # 经度取值范围为-180°~180°，保留小数点后5位数字。
-- # 纬度取值范围为-90°~90°，保留小数点后5位数字。
-- # 采用insert语句插入到表中
-- # 其它列的数据为测试值，在此处无实际意义。

insert into airline(ph, gd, hx, sd, sj, jwd) select 'A600', 5000, 200, 200, clock_timestamp(), ST_GeomFromText('POINT('|| trunc((0.5 - random())::numeric * 360, 5)::varchar || ' ' || trunc((0.5 - random())::numeric * 180, 5)::varchar || ')', 4326) from generate_series(1, 50000);

create index concurrently idx_airline_no on airline(no);
create index concurrently idx_airline_jwd on airline using gist(jwd);
create index concurrently idx_airline_sj on airline(sj);

select * from airline t where t.no = 9543;

select t.no, point(t.jwd) from airline as t where st_contains(ST_PolygonFromText('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))', 4326), t.jwd);

EXPLAIN (VERBOSE ON) select count(no) from airline as t where st_contains(ST_PolygonFromText('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))', 4326), t.jwd);

explain analyze select count(t.no) from airline as t where st_contains(ST_PolygonFromText('POLYGON((0 0, 64 0, 64 64, 0 64, 0 0))', 4326), t.jwd);

```