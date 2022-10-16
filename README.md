# modules-ec2-auto-stopper
Terraform module to automatically stop ec2 instances on a nightly basis.

## Usage
```HCL
module "auto_stopper" {
  source = "github.com/JDeBo/modules-ec2-auto-stopper.git"
  ec2_map = { <key> = <instance_id> }
  use_case = <YourUseCaseName>
}
```
