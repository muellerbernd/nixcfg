{ config, pkgs, lib, inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    # modules
    mixins-common
    mixins-i3
    mixins-hyprland
    # mixins-sway
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = [
        80
        443
        8080
        5000
        445 # samba
        137
        138
        139
      ];
      allowedUDPPorts = [
        80
        443
        8080
        5000
        445 # samba
        137
        138
        139
        # anyconnect?
        500
        4500
        51820 # wireguard
      ];
      allowedUDPPortRanges = lib.mkDefault [{
        from = 4000;
        to = 50000;
      }];
      # # ROS2 needs 7400 + (250 * Domain) + 1
      # # here Domain is 41 or 42
      # {
      #   from = 17650;
      #   to = 17910;
      # }
      # ];
      allowPing = lib.mkDefault true;
      # wireguard route all traffic through the tunnel
      # if packets are still dropped, they will show up in dmesg
      # logReversePathDrops = true;
      # # wireguard trips rpfilter up
      # extraCommands = ''
      #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      # '';
      # extraStopCommands = ''
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      # '';
    };
  };

  # for cross compilation of arm
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];


#   security.pki.certificates = [
#     "-----BEGIN CERTIFICATE-----
# MIIG5TCCBM2gAwIBAgIRANpDvROb0li7TdYcrMTz2+AwDQYJKoZIhvcNAQEMBQAw
# gYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtK
# ZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYD
# VQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTIw
# MDIxODAwMDAwMFoXDTMzMDUwMTIzNTk1OVowRDELMAkGA1UEBhMCTkwxGTAXBgNV
# BAoTEEdFQU5UIFZlcmVuaWdpbmcxGjAYBgNVBAMTEUdFQU5UIE9WIFJTQSBDQSA0
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApYhi1aEiPsg9ZKRMAw9Q
# r8Mthsr6R20VSfFeh7TgwtLQi6RSRLOh4or4EMG/1th8lijv7xnBMVZkTysFiPmT
# PiLOfvz+QwO1NwjvgY+Jrs7fSoVA/TQkXzcxu4Tl3WHi+qJmKLJVu/JOuHud6mOp
# LWkIbhODSzOxANJ24IGPx9h4OXDyy6/342eE6UPXCtJ8AzeumTG6Dfv5KVx24lCF
# TGUzHUB+j+g0lSKg/Sf1OzgCajJV9enmZ/84ydh48wPp6vbWf1H0O3Rd3LhpMSVn
# TqFTLKZSbQeLcx/l9DOKZfBCC9ghWxsgTqW9gQ7v3T3aIfSaVC9rnwVxO0VjmDdP
# FNbdoxnh0zYwf45nV1QQgpRwZJ93yWedhp4ch1a6Ajwqs+wv4mZzmBSjovtV0mKw
# d+CQbSToalEUP4QeJq4Udz5WNmNMI4OYP6cgrnlJ50aa0DZPlJqrKQPGL69KQQz1
# 2WgxvhCuVU70y6ZWAPopBa1ykbsttpLxADZre5cH573lIuLHdjx7NjpYIXRx2+QJ
# URnX2qx37eZIxYXz8ggM+wXH6RDbU3V2o5DP67hXPHSAbA+p0orjAocpk2osxHKo
# NSE3LCjNx8WVdxnXvuQ28tKdaK69knfm3bB7xpdfsNNTPH9ElcjscWZxpeZ5Iij8
# lyrCG1z0vSWtSBsgSnUyG/sCAwEAAaOCAYswggGHMB8GA1UdIwQYMBaAFFN5v1qq
# K0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBRvHTVJEGwy+lmgnryK6B+VvnF6DDAO
# BgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggr
# BgEFBQcDAQYIKwYBBQUHAwIwOAYDVR0gBDEwLzAtBgRVHSAAMCUwIwYIKwYBBQUH
# AgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFAGA1UdHwRJMEcwRaBDoEGGP2h0
# dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9u
# QXV0aG9yaXR5LmNybDB2BggrBgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6
# Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAl
# BggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0B
# AQwFAAOCAgEAUtlC3e0xj/1BMfPhdQhUXeLjb0xp8UE28kzWE5xDzGKbfGgnrT2R
# lw5gLIx+/cNVrad//+MrpTppMlxq59AsXYZW3xRasrvkjGfNR3vt/1RAl8iI31lG
# hIg6dfIX5N4esLkrQeN8HiyHKH6khm4966IkVVtnxz5CgUPqEYn4eQ+4eeESrWBh
# AqXaiv7HRvpsdwLYekAhnrlGpioZ/CJIT2PTTxf+GHM6cuUnNqdUzfvrQgA8kt1/
# ASXx2od/M+c8nlJqrGz29lrJveJOSEMX0c/ts02WhsfMhkYa6XujUZLmvR1Eq08r
# 48/EZ4l+t5L4wt0DV8VaPbsEBF1EOFpz/YS2H6mSwcFaNJbnYqqJHIvm3PLJHkFm
# EoLXRVrQXdCT+3wgBfgU6heCV5CYBz/YkrdWES7tiiT8sVUDqXmVlTsbiRNiyLs2
# bmEWWFUl76jViIJog5fongEqN3jLIGTG/mXrJT1UyymIcobnIGrbwwRVz/mpFQo0
# vBYIi1k2ThVh0Dx88BbF9YiP84dd8Fkn5wbE6FxXYJ287qfRTgmhePecPc73Yrzt
# apdRcsKVGkOpaTIJP/l+lAHRLZxk/dUtyN95G++bOSQqnOCpVPabUGl2E/OEyFrp
# Ipwgu2L/WJclvd6g+ZA/iWkLSMcpnFb+uX6QBqvD6+RNxul1FaB5iHY=
# -----END CERTIFICATE-----"
#     "-----BEGIN CERTIFICATE-----
# MIII/jCCBuagAwIBAgIQHwW8vYgQNwRovCPFvECZ+TANBgkqhkiG9w0BAQwFADBE
# MQswCQYDVQQGEwJOTDEZMBcGA1UEChMQR0VBTlQgVmVyZW5pZ2luZzEaMBgGA1UE
# AxMRR0VBTlQgT1YgUlNBIENBIDQwHhcNMjMxMTI0MDAwMDAwWhcNMjQxMTIzMjM1
# OTU5WjBTMQswCQYDVQQGEwJERTEPMA0GA1UECBMGQmF5ZXJuMRMwEQYDVQQKEwpG
# cmF1bmhvZmVyMR4wHAYDVQQDExVyZW1vdGV4LmZyYXVuaG9mZXIuZGUwggIiMA0G
# CSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/vApPLul5R2sUyD1MB7vNbwo1VE9X
# /1gt0P9vMKOyaYwXpKCm12AkVAlQgM+jy0J1zS4uAwd5/Y/Get3wq7tHPm2bzvpA
# AghU9intBPu4daZ3+aqGFHF+UjbfWjUXVsZdMHgg9uNj/TKb2QRbJtpLY9Yk0dLs
# gs6GwyWh3iKN9w/A/aUByHv3sroy0ydPNa6eukPb61cnzk7TNuwoqbc2t0rq7vF6
# M64h4beRI1k4q5oOCDKVuuV7hb647qKibfkeexPqAqGcWjZuJgA+UWCCVzqvW/EK
# xdY4YtBSTHAC4L0usMyAg4fhyGZnOqRgLthR79CSaVQ9WJToHfmiamjZNiq83Est
# 7duhrXMH8k/pXZhzAc72p5oiIJLc2pcFtND2msB8Ri7v07yiTQovBD705+WzrsJh
# 4UoK2FHE3+TvJ0p0BcI3XGNnDoNhLtisMagzAknvMB7+p3S5cDRp7VTAOT084HZa
# Lh2SAbS/UajTqqAlYRLgsCmhWLEFrzdmt7fq/KYNvTOd8NzCi+z0IXRQO3cGBJ1H
# dVCUItUoJCPBLbjf1Bw671hCW5PWAW76xD073GYbzNTfjuv0UPBc9Z41g3kFTS67
# AQbhv609hvbRrYExcbUICXiVD1yroN4bWd117rEQzQ394oMG9l9PhDROXQZi3Zb+
# qzABwS5O6f7XsQIDAQABo4ID2zCCA9cwHwYDVR0jBBgwFoAUbx01SRBsMvpZoJ68
# iugflb5xegwwHQYDVR0OBBYEFDT4+CEhFeUp3SFbQUL1Dqz/dcemMA4GA1UdDwEB
# /wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEF
# BQcDAjBJBgNVHSAEQjBAMDQGCysGAQQBsjEBAgJPMCUwIwYIKwYBBQUHAgEWF2h0
# dHBzOi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAECAjA/BgNVHR8EODA2MDSgMqAw
# hi5odHRwOi8vR0VBTlQuY3JsLnNlY3RpZ28uY29tL0dFQU5UT1ZSU0FDQTQuY3Js
# MHUGCCsGAQUFBwEBBGkwZzA6BggrBgEFBQcwAoYuaHR0cDovL0dFQU5ULmNydC5z
# ZWN0aWdvLmNvbS9HRUFOVE9WUlNBQ0E0LmNydDApBggrBgEFBQcwAYYdaHR0cDov
# L0dFQU5ULm9jc3Auc2VjdGlnby5jb20wggF+BgorBgEEAdZ5AgQCBIIBbgSCAWoB
# aAB2AHb/iD8KtvuVUcJhzPWHujS0pM27KdxoQgqf5mdMWjp0AAABjAF27+sAAAQD
# AEcwRQIgHO7xyT4emKfLfcvb0RhNG5R7g8kLg6bbwuDubWdmDqMCIQDTFFgvBvHy
# j4VQbeTYKvseEbbHbos9WxhmqEKAwbWjoAB2AD8XS0/XIkdYlB1lHIS+DRLtkDd/
# H4Vq68G/KIXs+GRuAAABjAF28BMAAAQDAEcwRQIhANwFYrdsZe8OoJXWkWzDtt9K
# FpByulGhLRW7W17VoMqdAiAPb9wC55D0N7u6rIdiGm8B3xUdoq2BBK5mIHzbjoj5
# AwB2AO7N0GTV2xrOxVy3nbTNE6Iyh0Z8vOzew1FIWUZxH7WbAAABjAF28BoAAAQD
# AEcwRQIgJkhfigdvt4WdAqZvL3j3PjhFntrDm9hU84HuZHzE2F8CIQDf/X4LEkiG
# xS8YByhTwbNJhr4NB2Ay6JSH80nle5H3STCB0gYDVR0RBIHKMIHHghVyZW1vdGV4
# LmZyYXVuaG9mZXIuZGWCFHJlbXgtMS5mcmF1bmhvZmVyLmRlghRyZW14LTIuZnJh
# dW5ob2Zlci5kZYIUcmVteC0zLmZyYXVuaG9mZXIuZGWCFHJlbXgtNC5mcmF1bmhv
# ZmVyLmRlghRyZW14LTUuZnJhdW5ob2Zlci5kZYIUcmVteC02LmZyYXVuaG9mZXIu
# ZGWCFHJlbXgtNy5mcmF1bmhvZmVyLmRlghRyZW14LTguZnJhdW5ob2Zlci5kZTAN
# BgkqhkiG9w0BAQwFAAOCAgEATfDHy6pOaev5neKLJPPmR5dyBRVsuZSn1GscuF2/
# HhqoNx/dNtndsfWfkGxa6NVis2F7T3vse9ThjF4j1yqeh9z4oRBIvbQ7ZwWXA3eY
# cgaJcUwGf0wGnedJ8leZSEbd+ISWgGU9ENTigiSnd8joSF4MXyzTUS4M9OIc3fbQ
# iVnoig1QD4c9grdM7LKvwOdO5fSFvlG1e00NJD32O/1r9IaGTje+SCLesHhWyldO
# ImJjQ0HwK+I7AegwzaewDb/wP8WfgnZPBnGSpnWmH2peeBtd08XnX3IgZn/GzpB/
# r+SVgGXz1F4yoA6leQz+lLKFNGsV6Ak2/yaj/4nGi+dgGPnaF/ZeOGBfW/H/ssex
# aqZnb2mm7j7p0Eecysy3NTtJxBjHSdmJ3SNMEf8eE2vodK5jWgdjneGoz7oLwI+P
# yyyuhsg8EaU3WKhwTHQvjml72ol5Jvb0DdDpDtMANUPbiXh+sLSa94kDbU7hIoM2
# euw4LvEBVFXj7tMAFVjvntxKe0b6qZB6UlGoHwv3uAmOZGKbQsv2fGSAvS8m1DaR
# tU79h06eHKEDd79vsMcSjIYIfSPrDAoYktU+fBFwp1hMllC5XYua4cLuXnl7lCF4
# eSVPOA5U70HMdg6nozB99funhspDQBk/AdIsr7F8Cr2iiyarU4XWibQ3EsxNgHo5
# Q7Q=
# -----END CERTIFICATE-----"
#     "-----BEGIN CERTIFICATE-----
# MIIF3jCCA8agAwIBAgIQAf1tMPyjylGoG7xkDjUDLTANBgkqhkiG9w0BAQwFADCB
# iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
# cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNV
# BAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTAw
# MjAxMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVU
# aGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2Vy
# dGlmaWNhdGlvbiBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQCAEmUXNg7D2wiz0KxXDXbtzSfTTK1Qg2HiqiBNCS1kCdzOiZ/MPans9s/B
# 3PHTsdZ7NygRK0faOca8Ohm0X6a9fZ2jY0K2dvKpOyuR+OJv0OwWIJAJPuLodMkY
# tJHUYmTbf6MG8YgYapAiPLz+E/CHFHv25B+O1ORRxhFnRghRy4YUVD+8M/5+bJz/
# Fp0YvVGONaanZshyZ9shZrHUm3gDwFA66Mzw3LyeTP6vBZY1H1dat//O+T23LLb2
# VN3I5xI6Ta5MirdcmrS3ID3KfyI0rn47aGYBROcBTkZTmzNg95S+UzeQc0PzMsNT
# 79uq/nROacdrjGCT3sTHDN/hMq7MkztReJVni+49Vv4M0GkPGw/zJSZrM233bkf6
# c0Plfg6lZrEpfDKEY1WJxA3Bk1QwGROs0303p+tdOmw1XNtB1xLaqUkL39iAigmT
# Yo61Zs8liM2EuLE/pDkP2QKe6xJMlXzzawWpXhaDzLhn4ugTncxbgtNMs+1b/97l
# c6wjOy0AvzVVdAlJ2ElYGn+SNuZRkg7zJn0cTRe8yexDJtC/QV9AqURE9JnnV4ee
# UB9XVKg+/XRjL7FQZQnmWEIuQxpMtPAlR1n6BB6T1CZGSlCBst6+eLf8ZxXhyVeE
# Hg9j1uliutZfVS7qXMYoCAQlObgOK6nyTJccBz8NUvXt7y+CDwIDAQABo0IwQDAd
# BgNVHQ4EFgQUU3m/WqorSs9UgOHYm8Cd8rIDZsswDgYDVR0PAQH/BAQDAgEGMA8G
# A1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQEMBQADggIBAFzUfA3P9wF9QZllDHPF
# Up/L+M+ZBn8b2kMVn54CVVeWFPFSPCeHlCjtHzoBN6J2/FNQwISbxmtOuowhT6KO
# VWKR82kV2LyI48SqC/3vqOlLVSoGIG1VeCkZ7l8wXEskEVX/JJpuXior7gtNn3/3
# ATiUFJVDBwn7YKnuHKsSjKCaXqeYalltiz8I+8jRRa8YFWSQEg9zKC7F4iRO/Fjs
# 8PRF/iKz6y+O0tlFYQXBl2+odnKPi4w2r78NBc5xjeambx9spnFixdjQg3IM8WcR
# iQycE0xyNN+81XHfqnHd4blsjDwSXWXavVcStkNr/+XeTWYRUc+ZruwXtuhxkYze
# Sf7dNXGiFSeUHM9h4ya7b6NnJSFd5t0dCy5oGzuCr+yDZ4XUmFF0sbmZgIn/f3gZ
# XHlKYC6SQK5MNyosycdiyA5d9zZbyuAlJQG03RoHnHcAP9Dc1ew91Pq7P8yF1m9/
# qS3fuQL39ZeatTXaw2ewh0qpKJ4jjv9cJ2vhsE/zB+4ALtRZh8tSQZXq9EfX7mRB
# VXyNWQKV3WKdwrnuWih0hKWbt5DHDAff9Yk2dDLWKMGwsAvgnEzDHNb842m1R0aB
# L6KCq9NjRHDEjf8tM7qtj3u1cIiuPhnPQCjY/MiQu12ZIvVS5ljFH4gxQ+6IHdfG
# jjxDah2nGN59PRbxYvnKkKj9
# -----END CERTIFICATE-----"
#   ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "23.05"; # Did you read the comment?
  system.stateVersion = "23.11"; # Did you read the comment?
}
