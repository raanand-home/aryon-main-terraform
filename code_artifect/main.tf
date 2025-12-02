# --- 1. AWS CodeArtifact Domain ---
# A CodeArtifact Domain acts as a container for repositories and is the central management point.
resource "aws_codeartifact_domain" "python_domain" {
  domain = "aryon" # Choose a unique name for your domain
}

# --- 2. AWS CodeArtifact Repository (Public PyPI Mirror) ---
# This repository connects to the public PyPI. Any packages requested will be fetched 
# from PyPI and cached in this repository for subsequent requests.
resource "aws_codeartifact_repository" "pypi_store" {
  repository = "pypi-external-store"
  domain     = aws_codeartifact_domain.python_domain.domain

  # Configure the external connection to the official PyPI
  external_connections {
    external_connection_name = "public:pypi"
  }

  tags = {
    Name = "CodeArtifact PyPI Mirror"
  }
}
data aws_caller_identity current {}
data aws_region current {}

# --- 3. AWS CodeArtifact Repository (Private Packages) ---
# This is the repository where your private Python packages will be published.
# It uses the PyPI mirror (pypi_store) as an upstream, so if a package is not 
# found in this private repo, it will look for it in PyPI.
resource "aws_codeartifact_repository" "private_repo" {
  repository = "private"
  domain     = aws_codeartifact_domain.python_domain.domain

  # Set the public mirror as an upstream repository
  upstream {
    repository_name = aws_codeartifact_repository.pypi_store.repository
  }

  tags = {
    Name = "Private Python Packages"
  }
}
output repository {
    value = aws_codeartifact_repository.private_repo
}
# --- 4. Output the Endpoint URL ---
# This output provides the URL you'll use in your pip or poetry configuration.
output "codeartifact_pypi_endpoint" {
  description = "The CodeArtifact PyPI repository endpoint URL for your private repo."
  value       = "https://${aws_codeartifact_domain.python_domain.domain}-${data.aws_caller_identity.current.account_id}.d.codeartifact.${data.aws_region.current.name}.amazonaws.com/pypi/${aws_codeartifact_repository.private_repo.repository}/simple/"
}
