let
  # User permission allows user key decription
  # System permission allows system key encryption
  
  user_bimtop    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJdXVkwzlYYwB2k3bmCl5JDLG4N5tbNYuP3vkyIxZ5P laptop-user";
  bimtop_host    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFP4jeXtDFvVkH8HnCxa564B7szlcNyh15NtSUg3ETKj laptop-host";

  user_bimserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDVXIZLvk2c68zJJG2/WjEM82qBi+l/6FWeB+e9rMFo server-user";
  bimserver_host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCk0wnxIm40bh18ypLgWHPUj1cu7CIhXQvLab5TzlVq server-host";
in
{
  "bimserver-deploy-key.age".publicKeys = [ user_bimtop bimserver_host ];
}