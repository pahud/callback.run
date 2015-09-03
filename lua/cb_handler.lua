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

local trigger_url = req_body.trigger_url
--if req_body.result ~= 'pass' then
res, err = httpc:request_uri(trigger_url..'&foo=bar', { ssl_verify=false } )
if err then
  ngx.log(ngx.ERR, "got err: ", err)
end
ngx.print( res.body )
--end
