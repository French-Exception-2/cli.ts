{
  "builders": [
    {
      "boot_command": [
        "<esc><wait>",
        "install <wait>",
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
        "debian-installer=en_US.UTF-8 <wait>",
        "auto <wait>",
        "locale=en_US.UTF-8 <wait>",
        "kbd-chooser/method=us <wait>",
        "keyboard-configuration/xkb-keymap=us <wait>",
        "netcfg/get_hostname={{ .Name }} <wait>",
        "netcfg/get_domain=vagrantup.com <wait>",
        "fb=false <wait>",
        "debconf/frontend=noninteractive <wait>",
        "console-setup/ask_detect=false <wait>",
        "console-keymaps-at/keymap=us <wait>",
        "grub-installer/bootdev=/dev/sda <wait>",
        "<enter><wait>"
      ],
      "boot_wait": "5s",
      "disk_size": 81920,
      "guest_additions_path": "VBoxGuestAdditions.iso",
      "guest_os_type": "Debian_64",
      "headless": true,
      "http_directory": "http",
      "iso_checksum": "sha256:396553f005ad9f86a51e246b1540c60cef676f9c71b95e22b753faef59f89bee",
      "iso_urls": [
        "iso/debian-{{user `os_version`}}-amd64-netinst.iso:",
        "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-{{user `os_version`}}-amd64-netinst.iso"
      ],
      "shutdown_command": "echo 'vagrant'|sudo -S shutdown -P now",
      "ssh_password": "vagrant",
      "ssh_port": 22,
      "ssh_timeout": "10000s",
      "ssh_username": "vagrant",
      "type": "virtualbox-iso",
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "1024"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "4"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--nicpromisc1",
          "allow-all"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--nicpromisc2",
          "allow-all"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--nicpromisc3",
          "allow-all"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--natdnshostresolver1",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--natdnsproxy1",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--ioapic",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--hwvirtex",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--hpet",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--nestedpaging",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--largepages",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--vtxvpid",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--vtxux",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--pae",
          "on"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--chipset",
          "ich9"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--biosapic",
          "x2apic"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--vrde",
          "off"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--usb",
          "off"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--vram",
          "8"
        ]
      ],
      "virtualbox_version_file": ".vbox_version",
      "vm_name": "packer-{{user `out`}}"
    }
  ],
  "post-processors": [
    [
      {
        "output": "builds/{{ user `out` }}.box",
        "type": "vagrant"
      }
    ]
  ],
  "provisioners": [
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/vagrant.sh",
      "type": "shell"
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/kernel.update.sh",
      "type": "shell",
      "environment_vars":[
        "kernel_version={{user `kernel_version` }}"
      ]
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/virtualbox.guest.additions.install.sh",
      "type": "shell"
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/ipv6.disable.sh",
      "type": "shell"
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/apt.configure.sh",
      "type": "shell",
      "environment_vars":[
        "keyboard_layout={{user `keyboard_layout`}}"
      ]
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/apt.configure.sh",
      "type": "shell"
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/apt.proxy.configure.sh",
      "type": "shell",
      "environment_vars": [
        "APT_IP=10.100.2.20"
      ]
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/docker.install.sh",
      "type": "shell"
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/k8s.install.sh",
      "type": "shell"
    },
    {
      "execute_command": "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
      "script": "provisioning/{{user `os_type`}}/{{user `os_version`}}/cleanup.sh",
      "type": "shell"
    }
  ],
  "variables": {
    "kernel_version": "5.9.0-0.bpo.5",
    "version": "0.0.1",
    "version_str": "0_0_1",
    "os_type": "debian_64",
    "ov_version": "10.8.0",
    "keyboard_layout": "fr",
    "box_kind": "docker-kubernetes",
    "vbox_group": "Frenchex2 VagrantI I2",
    "out": "{{.Provider}}-{{user `os_type`}}-{{user `os_version`}}-{{user `box_kind`}}-amd64"
  }
}