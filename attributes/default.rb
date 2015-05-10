default[:pacemaker][:src_filepath] = "/usr/local/src/pacemaker-1.0.13-2.1.el6.x86_64.repo.tar.gz"
default[:pacemaker][:extract_filepath] = "/usr/local/src/pacemaker-1.0.13-2.1.el6.x86_64.repo"
default[:pacemaker][:repo_filename] = "pacemaker.repo"
default[:pacemaker][:nodes] = ['s1', 's2']
default[:pacemaker][:nodes_ip]= ["192.168.9.121", "192.168.9.122"]
default[:pacemaker][:rpm_packages]= ["pacemaker-1.0.13-2.el6.x86_64.rpm", "pacemaker-libs-1.0.13-2.el6.x86_64.rpm", "libesmtp-1.0.4-16.el6.x86_64.rpm", "pm_extras-1.5-1.el6.x86_64.rpm"]
