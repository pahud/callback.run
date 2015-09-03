local cjson      = require "cjson"
local cjson_safe = require "cjson.safe"
local http       = require "resty.http"
local httpc      = http.new()
--local config   = ngx.shared.globalconfig;
local reqs       = {}
local resp       = {status="ok", reason="ok"}
ngx.req.read_body()
local body_data  = ngx.req.get_body_data();
local req_args   = ngx.req.get_uri_args()

ngx.log(ngx.ERR, "got runscope callback payload body_data=", body_data )
local req_body=cjson_safe.decode(body_data)

if req_body.result == 'pass' then
	ngx.log(ngx.ERR, '[OK]result=pass')
	return
end

local trigger_url = req_body.trigger_url
local ini_vars = req_body.initial_variables or {}
local has_retried = ini_vars.has_retried or 0
local max_retry = req_args.max_retry or 3
if not tonumber(max_retry) or tonumber(max_retry) > 5 or tonumber(max_retry) < 0 then
	max_retry = 3
end
ngx.log(ngx.ERR, '[INFO] max_retry set to ', max_retry)

--if req_body.result ~= 'pass' then
if tonumber(has_retried) < tonumber(max_retry) then
	ngx.log(ngx.ERR, "[INFO] start retry=", tostring(has_retried+1))
	ngx.log(ngx.ERR, "[INFO] requesting trigger_url: ", trigger_url..'?has_retried='..tostring(has_retried+1))
	res, err = httpc:request_uri(trigger_url..'?has_retried='..tostring(has_retried+1), { ssl_verify=false } )
	if err then
	  ngx.log(ngx.ERR, "[ERR] got err: ", err)
	else
	  ngx.log(ngx.ERR, "[INFO] trigger DONE")
	  ngx.log(ngx.ERR, res.body )
	  ngx.print( res.body )
	end
else
	ngx.log(ngx.ERR, '[INFO] max_retry reached' )
end

--end
