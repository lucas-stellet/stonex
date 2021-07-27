#!/bin/sh

mix ecto.setup; 

sleep 5 

mix phx.server
