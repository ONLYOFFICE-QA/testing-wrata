# docker workaround, see https://github.com/javan/whenever/issues/656#issuecomment-239111064
ENV.each { |k, v| env(k, v) }

every 1.minute do
  runner 'Runner::Application.config.threads.destroy_inactive_servers', output: 'log/server_destroyer.log'
end
