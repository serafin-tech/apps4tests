# BindPlane

tests for [BindPlane](https://docs.cloud.google.com/architecture/logging-and-monitoring-on-premises-resources-with-bindplane)

install instructions:

- [Getting started](https://docs.bindplane.observiq.com/docs/getting-started)
- [BindPlane Google edition](https://bindplane.com/google)

```txt
===================================================
| Information
===================================================
  Agent Home:         /opt/observiq-otel-collector
  Agent Config:       /opt/observiq-otel-collector/config.yaml
  Start Command:      sudo systemctl start observiq-otel-collector
  Stop Command:       sudo systemctl stop observiq-otel-collector
  Status Command:     sudo systemctl status observiq-otel-collector
  Logs Command:       sudo tail -F /opt/observiq-otel-collector/log/collector.log
  Uninstall Command:  sudo sh -c "$(curl -fsSlL https://bdot.bindplane.com/v1.95.0/install_unix.sh)" install_unix.sh -r
```
