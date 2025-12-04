import {
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';

import { MailService } from 'src/core/mail/mail.service';
import { UsersService } from '../users/users.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { UpdateDto } from './dto/update.dto';
import { JwtPayload } from './interfaces/jwt-payload.interface';

@Injectable()
export class AuthService {
  private readonly api_url = process.env.API_URL || 'http://172.17.74.223:3000';

  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly mailService: MailService,
  ) {}

  async register(registerDto: RegisterDto) {
    const { password, ...userData } = registerDto;

    const user = await this.usersService.create({
      ...userData,
      password: await bcrypt.hash(password, 10), // envia contraseña hasheada
    });

    // llama a la funcion que envia el token de registro con el nombre del usuario
    // para evitar consultar en la base de datos
    // const emailResult = await this.sendRegisterCode(userData.email);

    // return { message: 'Usuario registrado con exito', user, emailResult };

    return user;
  }

  async login(loginDto: LoginDto) {
    const { email, password } = loginDto;
    const user = await this.usersService.findOneByEmail(email);
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) throw new UnauthorizedException('Credenciales incorrectas');

    if (user.isVerified === false)
      throw new ConflictException('La cuenta no ha sido verificada');

    // const payload = { email: user.email, id: user.id };

    // const token = await this.jwtService.signAsync(payload);

    return {
      ...user,
      token: await this.getJwtToken({ email: user.email, id: user.id }),
    };
  }

  // Recibe el email y busca al usuario para obtener su nombre y enviar el token
  async sendRegisterCode(email) {
    const user = await this.usersService.findOneByEmail(email);

    if (!user)
      throw new NotFoundException('El email no se encuentra registrado');

    // Verifica si la cuenta ya ha sido activada
    if (user.isVerified)
      throw new ConflictException('La cuenta ya ha sido verificada');

    const name = user.name;

    // Crea el codigo que se enviara por correo
    const verificationCode = Math.floor(100000 + Math.random() * 900000);

    // Guarda el codigo en la base de datos
    await this.usersService.updateVerificationCode(user.id, verificationCode);

    // Envia el token por correo
    const htmlContent = `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9; border-radius: 10px;">
            <h1 style="color: #333; text-align: center;">Código de Verificación</h1>
            <p style="color: #666; font-size: 16px;">Hola ${name},</p>
            <p style="color: #666; font-size: 16px;">Tu código de verificación es:</p>
            <div style="background-color: #fff; 
                        padding: 20px; 
                        border-radius: 5px; 
                        text-align: center; 
                        margin: 25px 0;
                        border: 1px solid #e0e0e0;">
                <span style="font-size: 24px; 
                           font-weight: bold; 
                           color: #4CAF50; 
                           letter-spacing: 2px;">
                    ${verificationCode}
                </span>
            </div>
            <p style="color: #666; font-size: 14px; text-align: center;">
                Ingresa este código en la aplicación para verificar tu cuenta.
            </p>
        </div>
        `;

    return await this.mailService.sendMail(
      email,
      'Verificacion de cuenta',
      htmlContent,
    );
  }

  async verifyCode(email, registerCode: string) {
    const user = await this.usersService.findOneByEmail(email);

    // Parsea el codigo a entero
    const NumberRegisterCode = parseInt(registerCode);

    if (!user)
      throw new NotFoundException('El email no se encuentra registrado');

    if (user.verification_code !== NumberRegisterCode)
      throw new UnauthorizedException(
        'El codigo de verificación no es correcto',
      );

    // Activa la cuenta
    await this.usersService.updateActive(user.id, true);

    // Crea el mismo token de login
    const payload = { email: user.email, id: user.id };

    const token = await this.jwtService.signAsync(payload);

    return {
      statusCode: 200,
      message: 'La cuenta ha sido verificada con exito',
      user,
      token,
    };
  }

  async updateEmail(email, { name, password }: UpdateDto) {
    const user = await this.usersService.findOneByEmail(email);

    if (!user)
      throw new UnauthorizedException('El email no se encuentra registrado');

    return await this.usersService.updateWithEmail(email, {
      name,
      password: await bcrypt.hash(password, 10),
    });
  }

  async updateWithId(id, { name, password }: UpdateDto) {
    const user = await this.usersService.findOneById(id);

    if (!user)
      throw new UnauthorizedException('El id no se encuentra registrado');

    if (!name)
      return await this.usersService.update(id, {
        password: await bcrypt.hash(password, 10),
      });

    if (!password) return await this.usersService.update(id, { name });

    return await this.usersService.update(id, {
      name,
      password: await bcrypt.hash(password, 10),
    });
  }

  private getJwtToken(payload: JwtPayload) {
    const token = this.jwtService.sign(payload);
    return token;
  }
}
