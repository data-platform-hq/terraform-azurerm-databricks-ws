## [1.8.1](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.8.0...v1.8.1) (2024-07-02)


### Bug Fixes

* add disk_encryption_set_id to outputs ([d1f1564](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/d1f1564c48d6cd78c0f88f0aad722b8e6ee8a14d))

# [1.8.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.7.3...v1.8.0) (2024-05-24)


### Bug Fixes

* added security KICS scan action ([59cfce5](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/59cfce5905b002980ab8e9260d90ba72189052fb))
* replaced pre-commit repo docs creation/update by GH Actions ([f466020](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/f46602046c039c8c951fdfaee56a6023851a374e))


### Features

* dbfs firewall ([bfe9036](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/bfe90361d952fedeaa48c21c37f479136274dc8a))

## [1.7.3](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.7.2...v1.7.3) (2023-12-23)


### Bug Fixes

* the name of the managed resource group is parameterized ([5d16a59](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/5d16a59fbbcdf7415797836174db3ee9040b005f))

## [1.7.2](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.7.1...v1.7.2) (2023-12-01)


### Bug Fixes

* output identity ([4888f0c](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/4888f0c44a9a9fedd908ca68e0954566f0499f3f))

## [1.7.1](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.7.0...v1.7.1) (2023-10-29)


### Bug Fixes

* readme update; managed disk identity kv policy ([7995a27](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/7995a27ab4c4dcac058904b52dd53f08bf47f0ee))

# [1.7.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.6.1...v1.7.0) (2023-10-05)


### Features

* encryption support; updated naming convention ([9f6c440](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/9f6c4400b76d38a75814796c3e7f37cca26cefa1))

## [1.6.1](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.6.0...v1.6.1) (2023-07-20)


### Bug Fixes

* added lifecycle log_analytics_destination_type ([783e468](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/783e468107a55a1aaba067d7e18efe0b7acfbcb5))

# [1.6.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.5.0...v1.6.0) (2023-07-20)


### Features

* removed encyrption key creation; update key vault policy ([d87ff46](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/d87ff46682936b8224aa541a7ed981effbfc35a3))

# [1.5.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.4.0...v1.5.0) (2023-07-14)


### Bug Fixes

* updated module usage code example ([be142d1](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/be142d1c82ef1f6a3c818ea646ec15ace0bacf51))


### Features

* separated cmk key creation ([8fe8019](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/8fe80196fe8796c31b71ac7ef14d7076299ae196))

# [1.4.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.3.0...v1.4.0) (2023-03-08)


### Bug Fixes

* added whitespace before depends_on ([5e3bfc5](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/5e3bfc57f10ba9b5c567fb91421511f795deffdd))
* fmt ([83250c2](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/83250c2d7ebe2da094211f21904daa3c73b926c4))


### Features

* added custom names for resources ([9d1235a](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/9d1235ada0a565b3dbfc57963597c166697d4124))

# [1.3.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.2.2...v1.3.0) (2023-02-28)


### Bug Fixes

* add precondition ([b07d9cf](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/b07d9cf89c64496e8af9f1b523c7dacc7e48aa22))
* changed name key vault key ([61a04cb](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/61a04cb66473e7b0899df0f5c77187495898d5fd))
* changed resource name ([75f4ca5](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/75f4ca5d6da9bc8e8a57c643ea13ec96f7cce79a))
* changed resource name ([980832e](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/980832ecb34db7927c600cca33497696881c3981))
* changed varable name ([0ebc4f8](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/0ebc4f8c642251e5afab59117e9413bc6e9729c2))
* delete precondition form key ([71b6250](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/71b6250133eca6ee5efc99d6e05fc3331807e835))
* terraform fmt ([bea63c6](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/bea63c63ab77e0fb746b79430506385f2d0436b2))


### Features

* create cms for servies ([7137298](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/7137298c46b20e8036447c6c94c4aa2a5556dcf6))

## [1.2.2](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.2.1...v1.2.2) (2023-02-02)


### Bug Fixes

* removed logs retention parameter ([ee50ff5](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/ee50ff5960a4a4582b3df11be4823075f879b32a))

## [1.2.1](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.2.0...v1.2.1) (2023-02-02)


### Bug Fixes

* changed for_each  condition ([0869687](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/08696872b2acc933e18db808b8dd13f7ac355732))
* chenged diagnostic check ([42c29ea](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/42c29ea82ae9016195004a24e42a9f06174689f2))
* chenged suffix to local.suffix ([e2d011f](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/e2d011f4101cd87cee9218b6b2d2f2d2937fe7fa))
* terraform fmt ([15726ca](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/15726ca103ef1885eb07500a7529adb8659ca990))

# [1.2.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.1.0...v1.2.0) (2023-01-26)


### Bug Fixes

* added proper suffix ([0c57822](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/0c57822ca8e31e725e5a8b31d4ffcedb01f0ba52))
* lint ([e25e093](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/e25e0930cd6d9cad51238138885d4d23a688769b))
* misspell ([2580c80](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/2580c80f552df02abf886a1dd8a7c32dcf5b9370))
* removed space ([70207fd](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/70207fd8462bd7b0be9657e213c536944c1cba1e))
* updated log variable list ([e26c317](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/e26c3179028655606f1280fcd998cda7ffe6945f))


### Features

* diagnostic-settings ([47627b3](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/47627b3502f10cfb7803f0587d7578a93ef4eebf))

# [1.1.0](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/compare/v1.0.0...v1.1.0) (2022-12-22)


### Features

* access connector ([71e0b16](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/71e0b167d87dde592d61bba3b429bdce529df8b5))

# 1.0.0 (2022-10-21)


### Features

* added README.md and fixed few typo in the variables.tf ([24dad86](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/24dad86845ee6b1c794c38c4a3d15f2ed59f146a))
* databricks module ([ce796da](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/commit/ce796da94dfeb4119bd1a546a5063708d9d9200f))
