/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Implementation of vector, matrix, and quaternion utility functions.
*/

#import "AAPLMathUtilities.h"
#include <assert.h>

float degrees_from_radians(float radians) {
    return (radians / M_PI) * 180;
}

float radians_from_degrees(float degrees) {
    return (degrees / 180) * M_PI;
}

static vector_float3 AAPL_SIMD_OVERLOAD vector_make(float x, float y, float z) {
    return (vector_float3){ x, y, z };
}

vector_float3 AAPL_SIMD_OVERLOAD vector_lerp(vector_float3 v0, vector_float3 v1, float t) {
    return ((1 - t) * v0) + (t * v1);
}

vector_float4 AAPL_SIMD_OVERLOAD vector_lerp(vector_float4 v0, vector_float4 v1, float t) {
    return ((1 - t) * v0) + (t * v1);
}

static matrix_float3x3 AAPL_SIMD_OVERLOAD matrix_make(float m00, float m10, float m20,
                                                      float m01, float m11, float m21,
                                                      float m02, float m12, float m22)
{
    return (matrix_float3x3){ { { m00, m10, m20 }, { m01, m11, m21 }, { m02, m12, m22 } } };
}

static matrix_float3x3 AAPL_SIMD_OVERLOAD matrix_make(vector_float3 col0, vector_float3 col1, vector_float3 col2) {
    return (matrix_float3x3){ col0, col1, col2 };
}

matrix_float3x3 AAPL_SIMD_OVERLOAD matrix3x3_from_quaternion(quaternion_float q) {
    float xx = q.x * q.x;
    float xy = q.x * q.y;
    float xz = q.x * q.z;
    float xw = q.x * q.w;
    float yy = q.y * q.y;
    float yz = q.y * q.z;
    float yw = q.y * q.w;
    float zz = q.z * q.z;
    float zw = q.z * q.w;
    
    float m00 = 1 - 2 * (yy + zz);
    float m01 = 2 * (xy - zw);
    float m02 = 2 * (xz + yw);
    
    float m10 = 2 * (xy + zw);
    float m11 = 1 - 2 * (xx + zz);
    float m12 = 2 * (yz - xw);
    
    float m20 = 2 * (xz - yw);
    float m21 = 2 * (yz + xw);
    float m22 = 1 - 2 * (xx + yy);
    
    return matrix_make(m00, m10, m20,
                       m01, m11, m21,
                       m02, m12, m22);
}

matrix_float3x3 AAPL_SIMD_OVERLOAD matrix3x3_rotation(float radians, vector_float3 axis) {
    axis = vector_normalize(axis);
    float ct = cosf(radians);
    float st = sinf(radians);
    float ci = 1 - ct;
    float x = axis.x, y = axis.y, z = axis.z;
    return matrix_make(ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st,
                       x * y * ci - z * st, ct + y * y * ci, z * y * ci + x * st,
                       x * z * ci + y * st, y * z * ci - x * st, ct + z * z * ci);
}

matrix_float3x3 AAPL_SIMD_OVERLOAD matrix3x3_rotation(float radians, float x, float y, float z) {
    return matrix3x3_rotation(radians, vector_make(x, y, z));
}

matrix_float3x3 AAPL_SIMD_OVERLOAD matrix3x3_scale(float sx, float sy, float sz) {
    return matrix_make(sx, 0, 0, 0, sy, 0, 0, 0, sz);
}

matrix_float3x3 AAPL_SIMD_OVERLOAD matrix3x3_scale(vector_float3 s) {
    return matrix_make(s.x, 0, 0, 0, s.y, 0, 0, 0, s.z);
}

matrix_float3x3 AAPL_SIMD_OVERLOAD matrix_inverse_transpose(matrix_float3x3 m) {
    return matrix_invert(matrix_transpose(m));
}

static matrix_float4x4 AAPL_SIMD_OVERLOAD matrix_make(float m00, float m10, float m20, float m30,
                                                      float m01, float m11, float m21, float m31,
                                                      float m02, float m12, float m22, float m32,
                                                      float m03, float m13, float m23, float m33)
{
    return (matrix_float4x4){ {
        { m00, m10, m20, m30 },
        { m01, m11, m21, m31 },
        { m02, m12, m22, m32 },
        { m03, m13, m23, m33 } } };
}

matrix_float4x4 AAPL_SIMD_OVERLOAD matrix4x4_from_quaternion(quaternion_float q) {
    float xx = q.x * q.x;
    float xy = q.x * q.y;
    float xz = q.x * q.z;
    float xw = q.x * q.w;
    float yy = q.y * q.y;
    float yz = q.y * q.z;
    float yw = q.y * q.w;
    float zz = q.z * q.z;
    float zw = q.z * q.w;
    
    float m00 = 1 - 2 * (yy + zz);
    float m01 = 2 * (xy - zw);
    float m02 = 2 * (xz + yw);
    
    float m10 = 2 * (xy + zw);
    float m11 = 1 - 2 * (xx + zz);
    float m12 = 2 * (yz - xw);
    
    float m20 = 2 * (xz - yw);
    float m21 = 2 * (yz + xw);
    float m22 = 1 - 2 * (xx + yy);
    
    return matrix_make(m00, m10, m20, 0,
                       m01, m11, m21, 0,
                       m02, m12, m22, 0,
                       0, 0, 0, 1);
}

matrix_float4x4 AAPL_SIMD_OVERLOAD matrix4x4_rotation(float radians, vector_float3 axis) {
    axis = vector_normalize(axis);
    float ct = cosf(radians);
    float st = sinf(radians);
    float ci = 1 - ct;
    float x = axis.x, y = axis.y, z = axis.z;
    return matrix_make(ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0,
                       x * y * ci - z * st, ct + y * y * ci, z * y * ci + x * st, 0,
                       x * z * ci + y * st, y * z * ci - x * st, ct + z * z * ci, 0,
                       0, 0, 0, 1);
}

matrix_float4x4 AAPL_SIMD_OVERLOAD matrix4x4_rotation(float radians, float x, float y, float z) {
    return matrix4x4_rotation(radians, vector_make(x, y, z));
}

matrix_float4x4 AAPL_SIMD_OVERLOAD matrix4x4_scale(float sx, float sy, float sz) {
    return matrix_make(sx, 0, 0, 0,
                       0, sy, 0, 0,
                       0, 0, sz, 0,
                       0, 0, 0, 1);
}

matrix_float4x4 AAPL_SIMD_OVERLOAD matrix4x4_scale(vector_float3 s) {
    return matrix_make(s.x, 0, 0, 0,
                       0, s.y, 0, 0,
                       0, 0, s.z, 0,
                       0, 0, 0, 1);
}

matrix_float4x4 matrix4x4_translation(float tx, float ty, float tz) {
    return matrix_make(1, 0, 0, 0,
                       0, 1, 0, 0,
                       0, 0, 1, 0,
                       tx, ty, tz, 1);
}

matrix_float4x4 matrix_look_at(float eyeX, float eyeY, float eyeZ,
                               float centerX, float centerY, float centerZ,
                               float upX, float upY, float upZ)
{
    vector_float3 eye = vector_make(eyeX, eyeY, eyeZ);
    vector_float3 center = vector_make(centerX, centerY, centerZ);
    vector_float3 up = vector_make(upX, upY, upZ);
    
    vector_float3 z = vector_normalize(eye - center);
    vector_float3 x = vector_normalize(vector_cross(up, z));
    vector_float3 y = vector_cross(z, x);
    vector_float3 t = vector_make(-vector_dot(x, eye), -vector_dot(y, eye), -vector_dot(z, eye));
    
    return matrix_make(x.x, y.x, z.x, 0,
                       x.y, y.y, z.y, 0,
                       x.z, y.z, z.z, 0,
                       t.x, t.y, t.z, 1);
}

matrix_float4x4 matrix_ortho(float left, float right, float bottom, float top, float nearZ, float farZ) {
    return matrix_make(2 / (right - left), 0, 0, 0,
                       0, 2 / (top - bottom), 0, 0,
                       0, 0, 1 / (farZ - nearZ), 0,
                       (left + right) / (left - right), (top + bottom) / (bottom - top), nearZ / (nearZ - farZ), 1);
}

matrix_float4x4 matrix_perspective(float fovyRadians, float aspect, float nearZ, float farZ) {
    float ys = 1 / tanf(fovyRadians * 0.5);
    float xs = ys / aspect;
    float zs = farZ / (nearZ - farZ);
    return matrix_make(xs, 0, 0, 0,
                       0, ys, 0, 0,
                       0, 0, zs, -1,
                       0, 0, zs * nearZ, 0);
}

matrix_float3x3 matrix_upper_left_3x3(matrix_float4x4 m) {
    vector_float3 x = m.columns[0].xyz;
    vector_float3 y = m.columns[1].xyz;
    vector_float3 z = m.columns[2].xyz;
    return matrix_make(x, y, z);
}

matrix_float4x4 AAPL_SIMD_OVERLOAD matrix_inverse_transpose(matrix_float4x4 m) {
    return matrix_invert(matrix_transpose(m));
}

quaternion_float AAPL_SIMD_OVERLOAD quaternion(float x, float y, float z, float w) {
    return (quaternion_float){ x, y, z, w };
}

quaternion_float AAPL_SIMD_OVERLOAD quaternion(vector_float3 v, float w) {
    return (quaternion_float){ v.x, v.y, v.z, w };
}

quaternion_float AAPL_SIMD_OVERLOAD quaternion_from_axis_angle(vector_float3 axis, float radians) {
    float t = radians * 0.5;
    return quaternion(axis.x * sinf(t), axis.y * sinf(t), axis.z * sinf(t), cosf(t));
}

quaternion_float AAPL_SIMD_OVERLOAD quaternion(matrix_float3x3 m) {
    float m00 = m.columns[0].x;
    float m11 = m.columns[1].y;
    float m22 = m.columns[2].z;
    float x = sqrtf(1 + m00 - m11 - m22) * 0.5;
    float y = sqrtf(1 - m00 + m11 - m22) * 0.5;
    float z = sqrtf(1 - m00 - m11 + m22) * 0.5;
    float w = sqrtf(1 + m00 + m11 + m22) * 0.5;
    return quaternion(x, y, z, w);
}

quaternion_float AAPL_SIMD_OVERLOAD quaternion(matrix_float4x4 m) {
    return quaternion(matrix_upper_left_3x3(m));
}

float quaternion_length(quaternion_float q) {
    return vector_length(q);
}

float quaternion_length_squared(quaternion_float q) {
    return vector_length_squared(q);
}

vector_float3 quaternion_axis(quaternion_float q) {
    // This query doesn't make sense if w > 1, but we do our best by
    // forcing q to be a unit quaternion if it obviously isn't
    if (q.w > 1.0) {
        q = quaternion_normalize(q);
    }
    
    float axisLen = sqrtf(1 - q.w * q.w);
    
    if (axisLen < 1e-5) {
        // At lengths this small, direction is arbitrary
        return vector_make(1, 0, 0);
    } else {
        return vector_make(q.x / axisLen, q.y / axisLen, q.z / axisLen);
    }
}

float quaternion_angle(quaternion_float q) {
    return 2 * acosf(q.w);
}

quaternion_float quaternion_normalize(quaternion_float q) {
    return vector_normalize(q);
}

quaternion_float quaternion_inverse(quaternion_float q) {
    return quaternion_conjugate(q) / quaternion_length_squared(q);
}

quaternion_float quaternion_conjugate(quaternion_float q) {
    return quaternion(-q.x, -q.y, -q.z, q.w);
}

quaternion_float quaternion_multiply(quaternion_float q0, quaternion_float q1) {
    return quaternion(q0.y * q1.x + q0.x * q1.y + q0.z * q1.w - q0.w * q1.z,
                      q0.x * q1.z - q0.y * q1.w + q0.z * q1.x + q0.w * q1.y,
                      q0.x * q1.w + q0.y * q1.z - q0.z * q1.y + q0.w * q1.x,
                      q0.x * q1.x - q0.y * q1.y - q0.z * q1.z - q0.w * q1.w);
}

quaternion_float quaternion_slerp(quaternion_float q0, quaternion_float q1, float t) {
    float dot = vector_dot(q0, q1);
    
    if ((1 - dot) < 1e-5) {
        return vector_normalize(vector_lerp(q0, q1, t));
    }
    
    dot = fminf(fmaxf(-1, dot), 1);
    
    float angle = acosf(dot);
    float angleInc = t * angle;
    
    quaternion_float q2 = q1 + q0 * dot;
    q2 = vector_normalize(q2);
    
    return q0 * cosf(angleInc) + q2 * sinf(angleInc);
}

vector_float3 quaternion_rotate_vector(quaternion_float q, vector_float3 v) {
    
    vector_float3 qp = vector_make(q.x, q.y, q.z);
    float w = q.w;
    return 2 * vector_dot(qp, v) * qp +
           ((w * w) - vector_dot(qp, qp)) * v +
           2 * w * vector_cross(qp, v);
}
