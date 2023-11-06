## zsh

- zsh란 bash shell 같은 shell

- 여기서 shell 이란 리눅스 명령어를 통해 프로그램을 실행할 때 사용하는 인터페이스

- zsh 설치 후에 아래 명령어를 실행해서 파일을 열어서 환경변수를 추가할 수 있다

```bash
vi ~/.zshrc
# 여기서 ~(물결기호)는 홈 폴더로 이동하는 것을 말한다
# zsh 를 사용하기 때문에 bashrc가 아닌 zshrc로 이동하는 것이다
```

- 환경변수를 설정하는 이유는 경로 이동에 매우 복잡한 경우가 있는데 이렇게 환경변수를 추가해주면 해당 경로로 바로 이동할 수 있기 때문이다.

- 아래 명령어를 실행하면 환경변수 NVM_DIR추가된 것을 확인할 수 있다

```bash
code ~/.zshrc

...

export NVM_DIR=~/.nvm
```

- 이 때 cd 명령어를 실행하면 해당 경로로 바로 이동하게 된다

```bash
cd $NVM_DIR
```

---

## Reference

- [Mac M1: 환경변수(PATH)설정하기 : ZSH Ver.](https://velog.io/@corner3499/Mac-M1-%ED%99%98%EA%B2%BD%EB%B3%80%EC%88%98PATH%EC%84%A4%EC%A0%95%ED%95%98%EA%B8%B0-ZSH-Ver)
