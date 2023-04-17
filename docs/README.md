# Cloud Developer Workbench

The contents within this section contain markdown docs and other assets used to publish documentation as a site using `mkdocs` The actual documentation is contained within the `docs/workbench` folder.

To run the docs site locally run the following command from within the `docs/` folder

```sh
docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
```
