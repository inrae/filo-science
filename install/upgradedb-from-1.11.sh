#!/bin/bash
ROOT=install/pgsql
psql $ADDRESS -f "$ROOT/alter-1.11-25.0.sql"