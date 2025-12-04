import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class MailService {
  private transporter: nodemailer.Transporter;

  constructor(private configService: ConfigService) {
    this.transporter = nodemailer.createTransport({
      //aca se usan las credenciales SMTP que entrega el servicio
      //para desarrollo se usa MailTrap
      host: this.configService.get('SMTP_HOST'),
      port: Number(this.configService.get('SMTP_PORT')),
      //en desarrollo se usa secure false.
      //revisar como es en gmail o en el servicio que se use para produccion
      secure: false,
      auth: {
        user: this.configService.get('SMTP_USER'),
        pass: this.configService.get('SMTP_PASSWORD'),
      },
    });
  }
  // se crea la funcion sendMail que recibe el destinatario, el asunto y el contenido del correo.
  // esta funcion es la que se llama desde el servicio que se necesite para que sea ejecutada, por ejemplo
  // en el servicio de usuario para enviar el correo de confirmacion de cuenta.
  async sendMail(to: string, subject: string, html: string) {
    try {
      const mailOptions = {
        from: this.configService.get('SMTP_FROM'),
        to: to,
        subject: subject,
        html: html,
      };
      const info = await this.transporter.sendMail(mailOptions);
      return info;
      //llama a la funcion de nodemailer que envia el correo y retorna la info que es de este formato:
      /* {
                messageId: "<b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>",
                envelope: {
                    from: "sender@example.com",
                    to: ["receiver@example.com"]
                },
                accepted: ["receiver@example.com"],
                rejected: [],
                pending: [],
                response: "250 2.0.0 OK 1234567890 abcdef"
            }*/
    } catch (error) {
      throw new Error(`Error sending email: ${error.message}`);
    }
  }
}
