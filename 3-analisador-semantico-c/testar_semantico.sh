#!/bin/bash

try_count=4

function Warning
{
    echo -e "\n\n"
    echo -e "\e[43m                         \e[43m                             \e[49m"
    echo -e "\e[43m          \e[40m \e[43m\e[25m              \e[43m                             \e[49m"
    echo -e "\e[43m         \e[40m \e[43m \e[40m \e[43m\e[25m             \e[43m                             \e[49m"
    echo -e "\e[43m        \e[40m \e[43m  \e[43m \e[40m \e[43m\e[25m            \e[43m \e[40m     \e[43m \e[40m \e[43m   \e[40m \e[43m \e[40m   \e[43m \e[40m     \e[43m \e[40m     \e[43m \e[49m"
    echo -e "\e[43m       \e[40m \e[43m  \e[40m \e[43m  \e[40m \e[43m\e[43m\e[25m           \e[43m \e[40m \e[43m   \e[40m \e[43m \e[40m \e[43m   \e[40m \e[43m  \e[40m \e[43m  \e[40m \e[43m     \e[40m \e[43m   \e[40m \e[43m \e[49m"
    echo -e "\e[43m      \e[40m \e[43m   \e[40m \e[43m   \e[40m \e[43m\e[43m\e[25m          \e[43m \e[40m     \e[43m  \e[40m \e[43m \e[40m \e[43m   \e[40m \e[43m  \e[40m     \e[43m \e[40m \e[43m   \e[40m \e[43m \e[49m"
    echo -e "\e[43m     \e[40m \e[43m    \e[40m \e[43m    \e[40m \e[43m\e[43m\e[25m         \e[43m \e[40m \e[43m   \e[40m \e[43m  \e[40m \e[43m \e[40m \e[43m   \e[40m \e[43m      \e[40m \e[43m \e[40m \e[43m   \e[40m \e[43m \e[49m"
    echo -e "\e[43m    \e[40m \e[43m           \e[40m \e[43m\e[25m        \e[43m \e[40m \e[43m   \e[40m \e[43m   \e[40m \e[43m   \e[40m   \e[43m \e[40m     \e[43m \e[40m     \e[43m \e[49m"
    echo -e "\e[43m   \e[40m \e[43m      \e[40m \e[43m      \e[40m \e[43m\e[43m\e[25m       \e[43m                             \e[49m"
    echo -e "\e[43m  \e[40m \e[43m               \e[40m \e[43m\e[25m      \e[43m                             \e[49m"
    echo -e "\e[43m \e[40m                   \e[43m\e[25m     \e[43m                             \e[49m"
    echo -e "\e[43m                         \e[43m                             \e[49m"
}

function EndTests
{
    echo -e "\n\n"
    echo -e "       \e[41m                      \e[49m"
    echo -e "      \e[41m \e[107m                      \e[41m \e[49m"
    echo -e "     \e[41m \e[107m  \e[41m                    \e[107m  \e[41m \e[49m"
    echo -e "    \e[41m \e[107m  \e[41m                      \e[107m  \e[41m \e[49m"
    echo -e "   \e[41m \e[107m  \e[41m                        \e[107m  \e[41m \e[49m"
    echo -e "  \e[41m \e[107m  \e[41m                          \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m                            \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m\e[97m     Processo de testes     \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m\e[97m         finalizado!        \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m                            \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m                            \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m\e[97m         Bye, bye...        \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m\e[97m     The cake is a lie!     \e[107m  \e[41m \e[49m"
    echo -e " \e[41m \e[107m  \e[41m                            \e[107m  \e[41m \e[49m"
    echo -e "  \e[41m \e[107m  \e[41m                          \e[107m  \e[41m \e[49m"
    echo -e "   \e[41m \e[107m  \e[41m                        \e[107m  \e[41m \e[49m"
    echo -e "    \e[41m \e[107m  \e[41m                      \e[107m  \e[41m \e[49m"
    echo -e "     \e[41m \e[107m  \e[41m                    \e[107m  \e[41m \e[49m"
    echo -e "      \e[41m \e[107m                      \e[41m \e[49m"
    echo -e "       \e[41m                      \e[49m"
}

function PlayIntro
{
    clear
    let i=0

    while [ $i -lt 150 ]; do
        echo -e " "
        let i=i+1
    done;

    sleep 0.2s
    echo -e "\e[43m     \e[49m \e[43m     \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m     \e[49m \e[43m     \e[49m \e[43m \e[49m     \e[43m     \e[49m \e[43m     \e[49m"
    sleep 0.2s
    echo -e "\e[43m \e[49m     \e[43m \e[49m   \e[43m \e[49m \e[43m  \e[49m \e[43m  \e[49m \e[43m \e[49m   \e[43m \e[49m   \e[43m \e[49m   \e[43m \e[49m     \e[43m \e[49m     \e[43m \e[49m   \e[43m \e[49m"
    sleep 0.2s
    echo -e "\e[43m \e[49m     \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m \e[43m \e[49m \e[43m \e[49m \e[43m     \e[49m   \e[43m \e[49m   \e[43m \e[49m     \e[43m     \e[49m \e[43m     \e[49m"
    sleep 0.2s
    echo -e "\e[43m \e[49m     \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m       \e[43m \e[49m   \e[43m \e[49m     \e[43m \e[49m     \e[43m \e[49m  \e[43m \e[49m "
    sleep 0.2s
    echo -e "\e[43m     \e[49m \e[43m     \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m     \e[43m     \e[49m \e[43m     \e[49m \e[43m     \e[49m \e[43m \e[49m   \e[43m \e[49m"
    sleep 0.2s
    echo -e " "
    sleep 0.2s
    echo -e "            \e[43m \e[49m   \e[43m \e[49m \e[43m     \e[49m \e[43m     \e[49m \e[43m     \e[49m"
    sleep 0.2s
    echo -e "            \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m    " 
    sleep 0.2s
    echo -e "            \e[43m \e[49m \e[43m \e[49m \e[43m \e[49m \e[43m     \e[49m \e[43m     \e[49m \e[43m     \e[49m"
    sleep 0.2s
    echo -e "            \e[43m  \e[49m \e[43m  \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m  \e[43m \e[49m      \e[43m \e[49m"
    sleep 0.2s
    echo -e "            \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m \e[49m   \e[43m \e[49m \e[43m     \e[49m"
    echo -e "\n\n"
    sleep 1.0s
    echo -e "\e[33m  EPISODIO III: SEMANTICO - UMA NOVA ESPERANCA\e[39m"
    echo -e "\n\n"
    sleep 1.0s
    echo -e "\e[33mEh um periodo de guerra civil. A alianca rebelde\e[39m"
    #sleep 1.5s
    sleep 2.0s
    echo -e "\e[33mconseguiu roubar os codigos bison e flex da arma\e[39m"
    #sleep 1.5s
    sleep 2.0s
    echo -e "\e[33mdecisiva do Imperio, o COMPILADOR DA MORTE, um \e[39m"
    #sleep 1.5s
    sleep 2.0s
    echo -e "\e[33msoftware de batalha com poder suficiente para\e[39m"
    #sleep 1.5s
    sleep 2.0s
    echo -e "\e[33mcompilar os malwares mais poderosos da galaxia. \e[39m"
    #sleep 1.5s
    sleep 1.0s
    echo -e "\e[33m\n\e[39m"
    #sleep 1.5s
    sleep 1.0s
    echo -e "\e[33mOs rebeldes esperam encontrar uma vulnerabilidade\e[39m"
    #sleep 1.5s
    sleep 2.0s
    echo -e "\e[33mno analisador semantico do COMPILADOR DA MORTE e\e[39m"
    #sleep 1.5s
    sleep 2.0s
    echo -e "\e[33massim impedi-lo de espalhar malware em Dantooine.\e[39m"
    #sleep 1.5s
    sleep 1.0s
    echo -e "\e[33m\n\e[39m"
    #sleep 1.5s
    sleep 1.0s
    echo -e "\e[33mOs rebeldes so nao contavam com a astucia de um jovem\e[39m"
    #sleep 1.5s
    sleep 2.0s
    echo -e "\e[33mpadawan que esta prestes a se juntar ao Imperio...\e[39m"
    sleep 2.0s
    echo -e "\e[33m\n\e[39m"
    sleep 1.5s
    let i=0
    while [ $i -lt 45 ]; do
        echo -e " "
        sleep 0.2s
        let i=i+1
    done;
}

function DrawError
{
    echo -e "\n\n"
    echo -e "    \e[41m       \e[49m\e[39m"
    echo -e "   \e[41m         \e[49m\e[39m"
    echo -e "  \e[41m  \e[107m  \e[41m   \e[107m  \e[41m  \e[49m\e[39m"
    echo -e " \e[41m    \e[107m  \e[41m \e[107m  \e[41m    \e[49m\e[39m"
    echo -ne " \e[41m     \e[107m   \e[41m     \e[49m\e[39m"
    echo -e "       NENHUM TESTE CORRETO!!!"
    echo -e " \e[41m    \e[107m  \e[41m \e[107m  \e[41m    \e[49m\e[39m"
    echo -e "  \e[41m  \e[107m  \e[41m   \e[107m  \e[41m  \e[49m\e[39m"
    echo -e "   \e[41m         \e[49m\e[39m"
    echo -e "    \e[41m       \e[49m\e[39m"
}

function DrawSkull
{
    echo -e "\n\n"
    echo -e "                 \e[41m       \e[49m"
    echo -e "             \e[41m               \e[49m"
    echo -e "          \e[41m                     \e[49m"
    echo -e "         \e[41m                       \e[49m"
    echo -e "        \e[41m                         \e[49m"
    echo -e "       \e[41m                           \e[49m"
    echo -e "       \e[41m                           \e[49m"
    echo -e "       \e[41m        \e[49m   \e[41m     \e[49m   \e[41m        \e[49m"
    echo -e "       \e[41m      \e[49m      \e[41m   \e[49m       \e[41m     \e[49m"
    echo -e "        \e[41m    \e[49m       \e[41m   \e[49m       \e[41m    \e[49m"
    echo -e "        \e[41m    \e[49m      \e[41m     \e[49m      \e[41m    \e[49m"
    echo -e "         \e[41m          \e[49m   \e[41m          \e[49m"
    echo -e "          \e[41m         \e[49m   \e[41m         \e[49m"
    echo -e "            \e[41m                 \e[49m"
    echo -e "             \e[41m               \e[49m"
    echo -e "  \e[41m   \e[49m        \e[41m    \e[49m \e[41m \e[49m \e[41m \e[49m \e[41m \e[49m \e[41m    \e[49m       \e[41m   \e[49m"
    echo -e " \e[41m     \e[49m        \e[41m             \e[49m       \e[41m     \e[49m"
    echo -e "  \e[41m       \e[49m      \e[41m           \e[49m     \e[41m        \e[49m"
    echo -e "\e[41m              \e[49m    \e[41m     \e[49m    \e[41m              \e[49m"
    echo -e "\e[41m                    \e[49m   \e[41m                  \e[49m"
    echo -e " \e[41m   \e[49m      \e[41m               \e[49m \e[41m      \e[49m"
    echo -e "           \e[41m    \e[49m \e[41m               \e[49m"
    echo -e "  \e[41m                  \e[49m \e[41m                   \e[49m"
    echo -e "  \e[41m              \e[49m           \e[41m              \e[49m"
    echo -e "   \e[41m       \e[49m                      \e[41m        \e[49m"
    echo -e "     \e[41m    \e[49m                         \e[41m     \e[49m"
}

function Vader
{
    echo -e "\n\n"
    echo -e "           \e[47m       \e[49m          "
    echo -e "         \e[47m  \e[49m  \e[47m \e[49m \e[47m \e[49m  \e[47m  \e[49m        "
    echo -e "       \e[47m  \e[49m    \e[47m \e[49m \e[47m \e[49m    \e[47m  \e[49m      "
    echo -e "      \e[47m \e[49m      \e[47m \e[49m \e[47m \e[49m      \e[47m \e[49m     "
    echo -e "      \e[47m \e[49m      \e[47m \e[49m \e[47m \e[49m      \e[47m \e[49m     "
    echo -e "     \e[47m \e[49m       \e[47m \e[49m \e[47m \e[49m       \e[47m \e[49m    "
    echo -e "     \e[47m \e[49m       \e[47m \e[49m \e[47m \e[49m       \e[47m \e[49m    "
    echo -e "     \e[47m \e[49m       \e[47m \e[49m \e[47m \e[49m       \e[47m \e[49m    "
    echo -e "    \e[47m \e[49m        \e[47m \e[49m \e[47m \e[49m        \e[47m \e[49m    "
    echo -e "    \e[47m \e[49m    \e[47m     \e[49m \e[47m     \e[49m    \e[47m \e[49m    "
    echo -e "    \e[47m \e[49m   \e[47m \e[49m    \e[47m \e[49m \e[47m \e[49m    \e[47m \e[49m   \e[47m \e[49m    "
    echo -e "    \e[47m \e[49m  \e[47m  \e[49m     \e[47m \e[49m     \e[47m  \e[49m  \e[47m \e[49m    "
    echo -e "   \e[47m \e[49m   \e[47m \e[49m             \e[47m \e[49m   \e[47m \e[49m   "
    echo -e "   \e[47m \e[49m   \e[47m \e[49m             \e[47m \e[49m   \e[47m \e[49m   "
    echo -e "   \e[47m \e[49m  \e[47m  \e[49m     \e[47m \e[49m \e[47m \e[49m     \e[47m  \e[49m  \e[47m \e[49m   "
    echo -e "  \e[47m \e[49m   \e[47m \e[49m \e[47m     \e[49m   \e[47m     \e[49m \e[47m \e[49m   \e[47m \e[49m  "
    echo -e "  \e[47m \e[49m  \e[47m \e[49m        \e[47m \e[49m        \e[47m \e[49m  \e[47m \e[49m  "
    echo -e "  \e[47m \e[49m  \e[47m \e[49m     \e[47m \e[49m     \e[47m \e[49m     \e[47m \e[49m  \e[47m \e[49m  "
    echo -e "  \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m   \e[47m \e[49m  \e[47m \e[49m \e[47m \e[49m  \e[47m \e[49m   \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m  "
    echo -e " \e[47m \e[49m  \e[47m \e[49m  \e[47m \e[49m \e[47m \e[49m   \e[47m \e[49m \e[47m \e[49m   \e[47m \e[49m \e[47m \e[49m  \e[47m \e[49m  \e[47m \e[49m "
    echo -e " \e[47m \e[49m \e[47m  \e[49m   \e[47m \e[49m  \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m  \e[47m \e[49m   \e[47m  \e[49m \e[47m \e[49m "
    echo -e " \e[47m \e[49m \e[47m  \e[49m    \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m \e[47m \e[49m    \e[47m  \e[49m \e[47m \e[49m "
    echo -e "\e[47m \e[49m \e[47m  \e[49m    \e[47m \e[49m \e[47m  \e[49m \e[47m \e[49m \e[47m \e[49m \e[47m  \e[49m \e[47m \e[49m    \e[47m  \e[49m \e[47m \e[49m"
    echo -e "\e[47m \e[49m \e[47m  \e[49m       \e[47m       \e[49m       \e[47m  \e[49m \e[47m \e[49m"
    echo -e " \e[47m \e[49m  \e[47m      \e[49m         \e[47m      \e[49m  \e[47m \e[49m "
    echo -e "          \e[47m         \e[49m          "
}

function DrawDeathCompiler
{
    echo -e "\n\n"
    echo -e "          \e[47m          \e[49m"
    echo -e "        \e[47m   \e[49m        \e[47m   \e[49m"
    echo -e "       \e[47m  \e[49m    \e[47m    \e[49m    \e[47m  \e[49m"
    echo -e "      \e[47m  \e[49m     \e[47m    \e[49m     \e[47m  \e[49m"
    echo -e "     \e[47m  \e[49m    \e[47m        \e[49m    \e[47m  \e[49m"
    echo -e "    \e[47m  \e[49m  \e[47m \e[49m \e[47m          \e[49m \e[47m \e[49m  \e[47m  \e[49m"
    echo -e "    \e[47m \e[49m  \e[47m       \e[49m  \e[47m       \e[49m  \e[47m \e[49m"
    echo -e "   \e[47m  \e[49m \e[47m        \e[49m  \e[47m        \e[49m \e[47m  \e[49m"
    echo -e "   \e[47m \e[49m  \e[47m   \e[49m \e[47m    \e[49m  \e[47m    \e[49m \e[47m   \e[49m  \e[47m \e[49m"
    echo -e "  \e[47m  \e[49m \e[47m   \e[49m   \e[47m  \e[49m    \e[47m  \e[49m   \e[47m   \e[49m \e[47m  \e[49m"
    echo -e "  \e[47m \e[49m   \e[47m   \e[49m            \e[47m   \e[49m   \e[47m \e[49m"
    echo -e "  \e[47m \e[49m    \e[47m   \e[49m          \e[47m   \e[49m    \e[47m \e[49m"
    echo -e "  \e[47m \e[49m    \e[47m    \e[49m        \e[47m    \e[49m    \e[47m \e[49m"    
    echo -e "  \e[47m \e[49m    \e[47m    \e[49m        \e[47m    \e[49m    \e[47m \e[49m"
    echo -e "  \e[47m \e[49m    \e[47m   \e[49m          \e[47m   \e[49m    \e[47m \e[49m"
    echo -e "  \e[47m \e[49m   \e[47m   \e[49m            \e[47m   \e[49m   \e[47m \e[49m"
    echo -e "  \e[47m  \e[49m \e[47m   \e[49m   \e[47m  \e[49m    \e[47m  \e[49m   \e[47m   \e[49m \e[47m  \e[49m"
    echo -e "   \e[47m \e[49m  \e[47m   \e[49m \e[47m    \e[49m  \e[47m    \e[49m \e[47m   \e[49m  \e[47m \e[49m"
    echo -e "   \e[47m  \e[49m \e[47m        \e[49m  \e[47m        \e[49m \e[47m  \e[49m"
    echo -e "    \e[47m \e[49m  \e[47m       \e[49m  \e[47m       \e[49m  \e[47m \e[49m"
    echo -e "    \e[47m  \e[49m  \e[47m \e[49m \e[47m          \e[49m \e[47m \e[49m  \e[47m  \e[49m"
    echo -e "     \e[47m  \e[49m    \e[47m        \e[49m    \e[47m  \e[49m"
    echo -e "      \e[47m  \e[49m     \e[47m    \e[49m     \e[47m  \e[49m"
    echo -e "       \e[47m  \e[49m    \e[47m    \e[49m    \e[47m  \e[49m"
    echo -e "        \e[47m   \e[49m        \e[47m   \e[49m"
    echo -e "          \e[47m          \e[49m"
    echo -e "\n\n"
    echo -e "\e[33m  Bom trabalho jovem padawan!!!\e[39m"
    echo -e "\e[33m  O COMPILADOR DA MORTE esta completamente operacional.\e[39m"
}

function MenuFail
{
    let try_count=try_count-1
    if [ $try_count -gt 1  ];
    then
        echo -e "\n"
        echo -e "###       Resposta Incorreta!       ###"
        echo -e "###  Você possui mais \e[91m$try_count\e[39m tentativas! ###"
        echo -e "### Por favor, responda \e[92mSIM\e[39m ou \e[91mNAO\e[39m. ###\n"
    fi
    
    if [ $try_count == 1 ];
    then
        Warning
        echo -e "\n+-----------------------------------------------------------------+"
        echo -e "|                  Essa é a sua \e[91multima\e[39m tentativa!                 |"
        echo -e "| Por favor, responda \e[92mSIM\e[39m ou \e[91mNAO\e[39m ou este script sera EXTERMINADO. |"
        echo -e "+-----------------------------------------------------------------+\n"
    fi
    
    if [ $try_count == 0 ];
    then
        DrawSkull
        echo -e "\nI'll be back...\n"
        exit;
    fi    
}

corretos=0
failed=0
erro=0
continuar=0
executavel="";

clear
PlayIntro
clear
Warning
echo -e "\n"
echo -e "Para que voce venha para o \e[33mLado Negro da Forca \e[39me para"
echo -e "que o processo de compilacao e testes do analisador"
echo -e "semantico seja possivel, eh necessario que as seguintes"
echo -e "ferramentas estejam instaladas no seu computador:"
echo -e "\n"
echo -e "flex"
echo -e "bison"
echo -e "gcc"
echo -e "make"
echo -e "diff"
echo -e "unzip"
echo -e "\n"
echo -e "Se uma dessas ferramentas nao estiver presente, o processo"
echo -e "de compilacao e teste nao sera possivel. Tenha certeza de"
echo -e "que as mesmas estao instaladas no seu computador, pois este"
echo -e "script nao verifica a existencia das mesmas."
echo -e "\n"
Vader
echo -e "\n"
echo -e "\e[33m  Junte-se a mim, e venha para o Lado Negro da Forca!!!\e[33m"
echo -e "\e[33m  Juntos, nos iremos governar a Galaxia...\e[39m"
echo -e "\n"
while [ $continuar == 0 ]; do
    read -p "Voce deseja ir para o Lado Negro da Forca? [Sim/Nao] " yn
    case $yn in
        [Ss][Ii][Mm] ) continuar=1; break;;
        [Nn][Aa][Oo] ) EndTests; exit;;
        * ) MenuFail;;
    esac
done

echo -e "\n\n"
echo -e "+------------------------------------------------------+"
echo -e "|                                                      |"
echo -e "| Iniciando Processo de Teste do Analisador Semantico  |"
echo -e "|                                                      |"
echo -e "+------------------------------------------------------+\n"    

rm -Rf ./safe_box/*
rm -Rf ./saidas/*

echo -e "Procurando arquivo semantico.zip... \c"
if [ ! -e ./semantico.zip ];
then
    DrawSkull
    echo -e "\n\nERRO: Arquivo semantico.zip ***NAO*** encontrado!!!\n\n"
    exit
else
    echo -e "\e[92mOK\e[39m"    
fi

echo "Copiando arquivos..."
cp ./semantico.zip ./safe_box/
if [ ! -e ./safe_box/semantico.zip ];
then
    DrawSkull
    echo "Erro ao copiar arquivo semantico.zip para pasta safe_box!!!"
    exit
fi
echo "Descompactando..."
unzip -j -o -q ./safe_box/semantico.zip -d ./safe_box/

echo -e "Procurando Makefile... \c"
if [ ! -e ./safe_box/Makefile ];
then
    DrawSkull
    echo -e "\n\nERRO: Makefile ***NAO*** encontrado!!!\n\n"
    exit
else
    echo -e "\e[92mOK\e[39m"    
fi

echo -e "Compilando...\n\n"
make -C ./safe_box -I ./safe_box

if [ $erro == 0 ];
then
    if [ ! -e ./safe_box/semantico.exe ]; then
        if [ ! -e ./safe_box/semantico ]; then
           DrawSkull
           echo -e "\n\nErro de compilacao ou Executavel nao encontrado.\n\n"
           let erro=1
        else
           executavel="semantico"
        fi
    else
       executavel="semantico.exe"
    fi
fi

if [ $erro == 0 ];
then
    let corretos=0
    let failed=0
    
    echo -e "\n\nRealizando Testes..."
    for i in $(ls ./testes/*.c)
    do
        echo $i > linha.txt
        name=$(cut -d"/" -f3 linha.txt) 
        echo -ne "   Teste: \e[93m$name\e[39m"
        ./safe_box/$executavel < $i > ./saidas/$name.txt
        diff ./saidas/$name.txt ./saidas_padrao/"saida_"$name.txt > /dev/null
        rc=$?;
        if [ $rc == 0 ]; 
        then 
            echo -e " -> \e[92mOK\e[39m"
            let corretos=corretos+1
        fi
        if [ $rc == 1 ];
        then
            echo -e " -> \e[91mFail\e[39m"
            let failed=failed+1
        fi
        if [ $rc == 2 ];
        then
            echo -e " -> \e[91mUnexpected Problem.\e[39m"
            let failed=failed+1
        fi
    done
    echo -e "\n"
    echo -e "Corretos: \e[92m$corretos\e[39m"
    echo -e "Incorretos \e[91m$failed\e[39m"
    
    if [ $corretos == 50 ];
    then
        DrawDeathCompiler
    fi
    
    if [ $corretos == 0 ];
    then
        DrawError
    fi
    

fi

echo -e "\nApagando arquivos temporarios...\n"
rm -Rf ./safe_box/*
rm -Rf ./saidas/*
rm -Rf linha.txt
rm -f ./*stackdump*
let erro=0
