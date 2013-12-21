#!/usr/bin/env bats

@test "vagrantup.repo file exists" {
  run test -f /etc/yum.repos.d/vagrantup.repo
  [ "$status" -eq 0 ]
}

@test "vagrantup.repo has an epel baseurl" {
  run egrep 'baseurl\s*=\s*https://dl.fedoraproject.org/pub/epel/6/x86_64' /etc/yum.repos.d/vagrantup.repo
  [ "$status" -eq 0 ]
}
